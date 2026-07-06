import 'package:a7la2y/screens/auth/login/widget/login_widgets.dart';
import 'package:a7la2y/screens/auth/sigin/auth_flow_screen.dart';
import 'package:a7la2y/screens/auth/sigin/widget/custom_text_field.dart';
import 'package:a7la2y/screens/root/root%20barber.dart';
import 'package:a7la2y/screens/root/root%20clint.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFF7F7F7),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                  size: 14,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "مرحباً بك مجدداً",
                  style: GoogleFonts.zain(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "قم بتسجيل الدخول لمتابعة حجوزاتك.",
                  style: GoogleFonts.zain(
                    fontSize: 14,
                    color: const Color(0xFF7A7A7A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),

                CustomTextField(
                  hintText: "رقم الهاتف",
                  prefixIcon: Icons.phone_android_rounded,
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                ),
                CustomTextField(
                  hintText: "كلمة المرور",
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: true,
                  controller: _passwordController,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: Colors.black,
                            checkColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            side: const BorderSide(
                              color: Color(0xFFEFEFEF),
                              width: 1.5,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "تذكرني",
                          style: GoogleFonts.zain(
                            fontSize: 14,
                            color: const Color(0xFF7A7A7A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "نسيت كلمة المرور؟",
                        style: GoogleFonts.zain(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MainNavigationWrapper_barber(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "تسجيل الدخول",
                      style: GoogleFonts.zain(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: Color(0xFFEFEFEF), thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "أو سجل عبر",
                        style: GoogleFonts.zain(
                          fontSize: 13,
                          color: const Color(0xFF9E9E9E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: Color(0xFFEFEFEF), thickness: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    SocialLoginButton(
                      label: "",
                      iconText: Image.asset(
                        "assets/images/logo_16509564.png",
                        width: 24,
                        height: 24,
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),
                    SocialLoginButton(
                      label: "",
                      iconText: Image.asset(
                        "assets/images/apple-logo_747.png",
                        width: 24,
                        height: 24,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ليس لديك حساب؟",
                        style: GoogleFonts.zain(
                          fontSize: 14,
                          color: const Color(0xFF7A7A7A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AuthFlowScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "حساب جديد",
                          style: GoogleFonts.zain(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
