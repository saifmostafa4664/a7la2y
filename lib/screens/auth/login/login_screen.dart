import 'package:a7la2y/screens/auth/login/widget/login_widgets.dart';
import 'package:a7la2y/screens/auth/sigin/auth_flow_screen.dart';
import 'package:a7la2y/screens/root/root%20barber.dart';
import 'package:a7la2y/screens/root/root%20clint.dart';
import 'package:a7la2y/screens/root/root%20shops.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
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
              ),
            ),
          ),
          body: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      'مرحباً بك مجدداً',
                      style: GoogleFonts.zain(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'أدخل رقم هاتفك وسنرسل لك كود تحقق.',
                      style: GoogleFonts.zain(
                        fontSize: 14,
                        color: const Color(0xFF7A7A7A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 36),
                    _LoginFieldBox(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        cursorColor: Colors.black,
                        style: GoogleFonts.zain(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'رقم الهاتف',
                          hintStyle: GoogleFonts.zain(
                            fontSize: 14,
                            color: const Color(0xFFBDBDBD),
                          ),
                          prefixIcon: const Icon(
                            Icons.phone_android_rounded,
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
                    const SizedBox(height: 28),
                    _buildLoginButton(),
                    const SizedBox(height: 28),
                    _buildDivider(),
                    const SizedBox(height: 24),
                    _buildSocialRow(),
                    const SizedBox(height: 36),
                    _buildRegisterRow(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainNavigationWrapper_clint(),
            ),
          );
        },
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
          child: _isLoading
              ? const SizedBox(
                  key: ValueKey('loader'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  key: const ValueKey('label'),
                  'إرسال كود التحقق',
                  style: GoogleFonts.zain(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFEEEEEE), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'أو سجّل عبر',
            style: GoogleFonts.zain(
              fontSize: 13,
              color: const Color(0xFF9E9E9E),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFEEEEEE), thickness: 1)),
      ],
    );
  }

  Widget _buildSocialRow() {
    return Row(
      children: [
        SocialLoginButton(
          iconAsset: 'assets/images/logo_16509564.png',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MainNavigationWrapper_barber(),
              ),
            );
          },
        ),
        const SizedBox(width: 12),
        SocialLoginButton(
          iconAsset: 'assets/images/apple-logo_747.png',
          onTap: () {
             Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MainNavigationWrapper_shops(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRegisterRow() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ليس لديك حساب؟',
            style: GoogleFonts.zain(
              fontSize: 14,
              color: const Color(0xFF7A7A7A),
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AuthFlowScreen()),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'حساب جديد',
              style: GoogleFonts.zain(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginFieldBox extends StatelessWidget {
  final Widget child;

  const _LoginFieldBox({required this.child});

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
