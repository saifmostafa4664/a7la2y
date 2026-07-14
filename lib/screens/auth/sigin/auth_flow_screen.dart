import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthFlowScreen extends StatefulWidget {
  final String? prefillPhone;
  final bool startAtOtp;

  const AuthFlowScreen({super.key, this.prefillPhone, this.startAtOtp = false});

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

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
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

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.zain(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _nextStep() {
    // UI-only navigation - no authentication or registration logic
    if (_currentStep < _totalSteps - 1) {
      _animateToStep(_currentStep + 1);
    }
  }

  void _finalizeRegistration() {
    _showError('هذا تصميم واجهة مستخدم فقط - لا توجد عملية تسجيل حقيقية.');
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _animateToStep(_currentStep - 1);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _resendCode() {
    _showError('تم إعادة إرسال الكود بنجاح.');
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
    return Directionality(
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
                isLoading: false,
                onPressed: _nextStep,
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
                text: '$_selectedCountryCode ${_phoneController.text.trim()}',
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
              },
            );
          }),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'إعادة إرسال الكود',
              style: GoogleFonts.zain(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black,
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
            onPressed: () {},
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
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFF7F7F7),
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
