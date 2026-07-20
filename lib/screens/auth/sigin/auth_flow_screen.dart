import 'dart:async';

import 'package:a7la2y/core/injection_container.dart';
import 'package:a7la2y/core/utils/page_transitions.dart';
import 'package:a7la2y/features/auth/domain/repositories/auth_repository.dart';
import 'package:a7la2y/features/auth/presentation/cubit/phone_auth_cubit.dart';
import 'package:a7la2y/features/auth/presentation/cubit/phone_auth_state.dart';
import 'package:a7la2y/screens/root/root%20barber.dart';
import 'package:a7la2y/screens/root/root%20clint.dart';
import 'package:a7la2y/screens/root/root%20shops.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthFlowScreen extends StatefulWidget {
  final String? prefillPhone;
  final bool startAtOtp;
  final PhoneAuthCubit? phoneAuthCubit;
  final bool skipToProfile;
  final String? authenticatedUid;

  const AuthFlowScreen({
    super.key,
    this.prefillPhone,
    this.startAtOtp = false,
    this.phoneAuthCubit,
    this.skipToProfile = false,
    this.authenticatedUid,
  });

  @override
  State<AuthFlowScreen> createState() => _AuthFlowScreenState();
}

class _AuthFlowScreenState extends State<AuthFlowScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  static const int _totalSteps = 6;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  String _selectedRole = 'client';
  String _selectedCountryCode = '+20';
  bool _obscurePassword = true;
  bool _hasUploadedImage = false;
  bool _isLoading = false;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;

  late final PhoneAuthCubit _phoneAuthCubit;
  bool _ownsPhoneAuthCubit = false;

  int _resendCooldown = 0;
  Timer? _cooldownDisplayTimer;

  @override
  void initState() {
    super.initState();

    if (widget.phoneAuthCubit != null) {
      _phoneAuthCubit = widget.phoneAuthCubit!;
    } else {
      _phoneAuthCubit = sl<PhoneAuthCubit>();
      _ownsPhoneAuthCubit = true;
    }

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    if (widget.prefillPhone != null) {
      _phoneController.text = widget.prefillPhone!;
    }

    if (widget.startAtOtp) {
      _currentStep = 2;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.jumpToPage(2);
      });
    }

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _cooldownDisplayTimer?.cancel();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    if (_ownsPhoneAuthCubit) {
      _phoneAuthCubit.close();
    }
    super.dispose();
  }

  void _animateToStep(int step) {
    _fadeController.reset();
    _slideController.reset();
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
    _fadeController.forward();
    _slideController.forward();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _animateToStep(_currentStep + 1);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _animateToStep(_currentStep - 1);
    } else {
      Navigator.of(context).pop();
    }
  }

  String _normalizePhoneForDisplay() {
    final phone = _phoneController.text.trim();
    return '$_selectedCountryCode $phone';
  }

  String _normalizePhoneForAuth() {
    final phone = _phoneController.text.trim();
    if (phone.startsWith('0')) {
      return '$_selectedCountryCode${phone.substring(1)}';
    }
    return '$_selectedCountryCode$phone';
  }

  void _handleStepAction() {
    switch (_currentStep) {
      case 0:
        if (widget.skipToProfile) {
          _animateToStep(3);
        } else {
          _nextStep();
        }
        break;
      case 1:
        _onSendOtp();
        break;
      case 2:
        _onVerifyOtp();
        break;
      case 3:
        if (_nameController.text.trim().isEmpty) {
          _showError('أدخل اسمك الكامل.');
          return;
        }
        _nextStep();
        break;
      case 4:
        _nextStep();
        break;
      case 5:
        _onCompleteProfile();
        break;
    }
  }

  void _onSendOtp() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showError('أدخل رقم الهاتف.');
      return;
    }
    _phoneAuthCubit.verifyPhoneNumber(_normalizePhoneForAuth());
  }

  void _onVerifyOtp() {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 4) {
      _showError('أدخل رمز التحقق بالكامل.');
      return;
    }
    _phoneAuthCubit.verifySmsCode(otp);
  }

  void _onResendCode() {
    if (_resendCooldown > 0) return;
    _phoneAuthCubit.resendCode(_normalizePhoneForAuth());
  }

  Future<void> _onCompleteProfile() async {
    setState(() => _isLoading = true);

    try {
      final authRepo = sl<AuthRepository>();
      final uid = widget.authenticatedUid ?? authRepo.currentUser?.uid;

      if (uid == null) {
        _showError('حدث خطأ. حاول تسجيل الدخول مرة أخرى.');
        setState(() => _isLoading = false);
        return;
      }

      final updates = <String, dynamic>{
        'role': _selectedRole,
        'displayName': _nameController.text.trim(),
        'isProfileCompleted': true,
        'lastLoginAt': FieldValue.serverTimestamp(),
      };

      final email = _emailController.text.trim();
      if (email.isNotEmpty) {
        updates['email'] = email;
      }

      await authRepo.updateFirestoreUser(uid: uid, data: updates);

      if (!mounted) return;

      _routeByRole(_selectedRole);
    } catch (e) {
      _showError('فشل حفظ البيانات. حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _routeByRole(String role) {
    Widget destination;
    switch (role) {
      case 'barber':
        destination = const MainNavigationWrapper_barber();
        break;
      case 'salon_owner':
        destination = const MainNavigationWrapper_shops();
        break;
      default:
        destination = const MainNavigationWrapper_clint();
    }
    Navigator.pushAndRemoveUntil(
      context,
      FadeSlideRoute(page: destination),
      (route) => false,
    );
  }

  void _handlePhoneAuthState(PhoneAuthState state) {
    if (state is PhoneAuthLoading || state is PhoneAuthVerifying) {
      setState(() => _isLoading = true);
    } else if (state is PhoneAuthCodeSent) {
      setState(() => _isLoading = false);
      if (_currentStep == 1) {
        _animateToStep(2);
      }
      _startCooldownDisplay();
    } else if (state is PhoneAuthResendCooldown) {
      setState(() {
        _resendCooldown = state.secondsRemaining;
      });
    } else if (state is PhoneAuthSuccess) {
      setState(() => _isLoading = false);
      if (state.user.isProfileCompleted) {
        _routeByRole(state.user.role);
      } else {
        _animateToStep(3);
      }
    } else if (state is PhoneAuthAutoVerified) {
      setState(() => _isLoading = false);
      if (state.user.isProfileCompleted) {
        _routeByRole(state.user.role);
      } else {
        _animateToStep(3);
      }
    } else if (state is PhoneAuthError) {
      setState(() => _isLoading = false);
      _showError(state.message);
    }
  }

  void _startCooldownDisplay() {
    _resendCooldown = 60;
    _cooldownDisplayTimer?.cancel();
    _cooldownDisplayTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _resendCooldown--;
        if (_resendCooldown <= 0) {
          _resendCooldown = 0;
          timer.cancel();
        }
      });
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.zain(fontSize: 13, fontWeight: FontWeight.w600),
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static const List<String> _stepTitles = [
    'اختر هويتك',
    'التحقق من الهوية',
    'رمز التحقق',
    'بياناتك الشخصية',
    'كلمة المرور',
    'بريدك الإلكتروني',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      bloc: _phoneAuthCubit,
      listener: (context, state) => _handlePhoneAuthState(state),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _BackButton(onTap: _prevStep),
            ),
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: Text(
                _stepTitles[_currentStep],
                key: ValueKey(_currentStep),
                style: GoogleFonts.zain(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              _StepProgressBar(
                currentStep: _currentStep,
                totalSteps: _totalSteps,
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _wrapStep(_buildRoleStep()),
                    _wrapStep(_buildPhoneStep()),
                    _wrapStep(_buildOtpStep()),
                    _wrapStep(_buildNameStep()),
                    _wrapStep(_buildPasswordStep()),
                    _wrapStep(_buildEmailStep()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wrapStep(Widget content) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              content,
              const SizedBox(height: 36),
              _PrimaryButton(
                label: _currentStep == _totalSteps - 1
                    ? 'تأكيد وتفعيل الحساب'
                    : 'المتابعة',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _handleStepAction,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مرحباً بك في A7LA2Y',
          style: GoogleFonts.zain(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'حدد هويتك لتخصيص تجربتك داخل التطبيق.',
          style: GoogleFonts.zain(
            fontSize: 14,
            color: const Color(0xFF7A7A7A),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 28),
        _RoleCard(
          type: 'client',
          title: 'عميل',
          subtitle: 'أبحث عن حلاق أو صالون قريب',
          icon: Icons.person_search_rounded,
          selected: _selectedRole == 'client',
          onTap: () => setState(() => _selectedRole = 'client'),
        ),
        const SizedBox(height: 12),
        _RoleCard(
          type: 'barber',
          title: 'حلاق مستقل',
          subtitle: 'أعمل بحرية وأستقبل حجوزات',
          icon: Icons.content_cut_rounded,
          selected: _selectedRole == 'barber',
          onTap: () => setState(() => _selectedRole = 'barber'),
        ),
        const SizedBox(height: 12),
        _RoleCard(
          type: 'salon_owner',
          title: 'صاحب صالون',
          subtitle: 'أدير فريقاً وأجدول المواعيد',
          icon: Icons.store_rounded,
          selected: _selectedRole == 'salon_owner',
          onTap: () => setState(() => _selectedRole = 'salon_owner'),
        ),
      ],
    );
  }

  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'رقم هاتفك',
          style: GoogleFonts.zain(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'سنرسل رمز تحقق لتأكيد هويتك.',
          style: GoogleFonts.zain(
            fontSize: 14,
            color: const Color(0xFF7A7A7A),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 28),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFBFBFB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEFEFEF), width: 1.5),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: DropdownButton<String>(
                  value: _selectedCountryCode,
                  underline: const SizedBox(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black,
                    size: 18,
                  ),
                  style: GoogleFonts.zain(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  dropdownColor: Colors.white,
                  items: ['+20', '+966', '+971', '+964', '+965', '+974']
                      .map(
                        (code) => DropdownMenuItem(
                          value: code,
                          child: Text(code, textDirection: TextDirection.ltr),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCountryCode = v!),
                ),
              ),
              Container(width: 1, height: 26, color: const Color(0xFFEFEFEF)),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  textDirection: TextDirection.ltr,
                  cursorColor: Colors.black,
                  style: GoogleFonts.zain(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: '01xxxxxxxxx',
                    hintStyle: GoogleFonts.zain(
                      fontSize: 15,
                      color: const Color(0xFFBDBDBD),
                    ),
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'رمز التحقق',
          style: GoogleFonts.zain(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            style: GoogleFonts.zain(
              fontSize: 14,
              color: const Color(0xFF7A7A7A),
              fontWeight: FontWeight.w600,
            ),
            children: [
              const TextSpan(text: 'أُرسل إلى '),
              TextSpan(
                text: _normalizePhoneForDisplay(),
                style: GoogleFonts.zain(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(4, (i) {
            return _OtpCell(
              controller: _otpControllers[i],
              focusNode: _otpFocusNodes[i],
              onChanged: (value) {
                if (value.isNotEmpty && i < 3) {
                  FocusScope.of(context).requestFocus(_otpFocusNodes[i + 1]);
                } else if (value.isEmpty && i > 0) {
                  FocusScope.of(context).requestFocus(_otpFocusNodes[i - 1]);
                }
                if (i == 3 && value.isNotEmpty) {
                  final otp = _otpControllers.map((c) => c.text).join();
                  if (otp.length == 4) {
                    _onVerifyOtp();
                  }
                }
              },
            );
          }),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: _resendCooldown > 0 ? null : _onResendCode,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _resendCooldown > 0
                  ? Text(
                      'إعادة الإرسال بعد $_resendCooldown ث',
                      key: ValueKey('cooldown_$_resendCooldown'),
                      style: GoogleFonts.zain(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9E9E9E),
                      ),
                    )
                  : Text(
                      'إعادة إرسال الكود',
                      key: const ValueKey('resend_active'),
                      style: GoogleFonts.zain(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'بياناتك الشخصية',
          style: GoogleFonts.zain(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'أضف صورتك واسمك ليتعرف عليك الصالون.',
          style: GoogleFonts.zain(
            fontSize: 14,
            color: const Color(0xFF7A7A7A),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 28),
        Center(
          child: GestureDetector(
            onTap: () => setState(() => _hasUploadedImage = !_hasUploadedImage),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _hasUploadedImage
                        ? Colors.black
                        : const Color(0xFFF7F7F7),
                    border: Border.all(
                      color: _hasUploadedImage
                          ? Colors.black
                          : const Color(0xFFE0E0E0),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    _hasUploadedImage
                        ? Icons.check_rounded
                        : Icons.person_outline_rounded,
                    color: _hasUploadedImage
                        ? Colors.white
                        : const Color(0xFF9E9E9E),
                    size: 36,
                  ),
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: const Icon(
                    Icons.add_a_photo_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        _FieldBox(
          child: TextField(
            controller: _nameController,
            cursorColor: Colors.black,
            style: GoogleFonts.zain(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'الاسم بالكامل',
              hintStyle: GoogleFonts.zain(
                fontSize: 15,
                color: const Color(0xFFBDBDBD),
              ),
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: Color(0xFF9E9E9E),
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'كلمة المرور',
          style: GoogleFonts.zain(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'احرص على كتابة كلمة مرور قوية لحماية حسابك.',
          style: GoogleFonts.zain(
            fontSize: 14,
            color: const Color(0xFF7A7A7A),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 28),
        _FieldBox(
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            cursorColor: Colors.black,
            style: GoogleFonts.zain(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'كلمة المرور (6 أحرف على الأقل)',
              hintStyle: GoogleFonts.zain(
                fontSize: 14,
                color: const Color(0xFFBDBDBD),
              ),
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: Color(0xFF9E9E9E),
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF9E9E9E),
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'بريدك الإلكتروني',
          style: GoogleFonts.zain(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'سنرسل تفاصيل الفواتير وتأكيدات الحجز هنا. (اختياري)',
          style: GoogleFonts.zain(
            fontSize: 14,
            color: const Color(0xFF7A7A7A),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 28),
        _FieldBox(
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.black,
            textDirection: TextDirection.ltr,
            style: GoogleFonts.zain(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'example@mail.com',
              hintStyle: GoogleFonts.zain(
                fontSize: 15,
                color: const Color(0xFFBDBDBD),
              ),
              prefixIcon: const Icon(
                Icons.alternate_email_rounded,
                color: Color(0xFF9E9E9E),
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: _isLoading ? null : _onCompleteProfile,
            style: TextButton.styleFrom(foregroundColor: Colors.black54),
            child: Text(
              'تخطي هذه الخطوة',
              style: GoogleFonts.zain(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF9E9E9E),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepProgressBar({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
      child: Row(
        children: List.generate(totalSteps, (i) {
          final bool isActive = i <= currentStep;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              height: 3,
              margin: EdgeInsets.only(right: i < totalSteps - 1 ? 4 : 0),
              decoration: BoxDecoration(
                color: isActive ? Colors.black : const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFF7F7F7),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
          size: 14,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _PrimaryButton({
    required this.label,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF444444),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? const SizedBox(
                  key: ValueKey('loader'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  key: const ValueKey('label'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.zain(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                  ],
                ),
        ),
      ),
    );
  }
}

class _FieldBox extends StatelessWidget {
  final Widget child;

  const _FieldBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFEFEF), width: 1.5),
      ),
      child: child,
    );
  }
}

class _OtpCell extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpCell({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFBFBFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEFEFEF), width: 1.5),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          maxLength: 1,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          cursorColor: Colors.black,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: GoogleFonts.zain(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String type;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: selected ? Colors.black : const Color(0xFFFBFBFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Colors.black : const Color(0xFFEFEFEF),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? Colors.white.withValues(alpha: 0.12)
                    : const Color(0xFFF0F0F0),
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : Colors.black,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.zain(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: selected ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.zain(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? Colors.white.withValues(alpha: 0.7)
                          : const Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: selected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
