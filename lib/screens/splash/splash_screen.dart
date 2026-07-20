import 'package:a7la2y/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:a7la2y/features/auth/presentation/cubit/auth_state.dart';
import 'package:a7la2y/screens/root/root%20barber.dart';
import 'package:a7la2y/screens/root/root%20clint.dart';
import 'package:a7la2y/screens/root/root%20shops.dart';
import 'package:a7la2y/screens/splash/widget/CustomProgressBar.dart';
import 'package:a7la2y/screens/start/OnboardingItem.dart';
import 'package:a7la2y/screens/auth/login/login_screen.dart';
import 'package:a7la2y/core/utils/page_transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeAndRoute();
  }

  Future<void> _initializeAndRoute() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    context.read<AuthCubit>().checkAuthStatus();
  }

  void _navigateTo(Widget screen) {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    Navigator.pushReplacement(
      context,
      FadeRoute(page: screen),
    );
  }

  void _routeByRole(String role) {
    switch (role) {
      case 'barber':
        _navigateTo(const MainNavigationWrapper_barber());
        break;
      case 'salon_owner':
        _navigateTo(const MainNavigationWrapper_shops());
        break;
      default:
        _navigateTo(const MainNavigationWrapper_clint());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (state.user.isProfileCompleted) {
            _routeByRole(state.user.role);
          } else {
            _navigateTo(const LoginScreen());
          }
        } else if (state is AuthUnauthenticated || state is AuthError) {
          _navigateTo(const OneScreen());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "A7LA2Y",
                style: GoogleFonts.inter(
                  fontSize: 46,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
            const Gap(8),
            Text(
              "Your favorite app for everything!",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF7A7A7A),
              ),
            ),
            const Gap(16),
            const CustomProgressBar(width: 100, height: 10),
          ],
        ),
      ),
    );
  }
}
