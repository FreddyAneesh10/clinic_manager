import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/router/auth_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() async {
    // Simulate loading progress
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (mounted) {
        setState(() {
          _progress = i / 100;
        });
      }
    }
    if (mounted) {
      context.go(AuthRouter.signup); // Navigate to signup as requested
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: Column(
          children: [
            const Spacer(flex: 3),
            // Logo Container
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),
            // App Name
            Text(
              'TaskTrack',
              style: AppTypography.h1.copyWith(
                fontSize: 48,
                letterSpacing: -1,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            // Subtitle
            Text(
              'NOCTURNAL INTELLIGENCE',
              style: AppTypography.splashSubtitle,
            ),
            const Spacer(flex: 2),
            // Loading Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'INITIALIZING ENVIRONMENT',
                    style: AppTypography.label.copyWith(
                      letterSpacing: 1.2,
                      fontSize: 10,
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
