import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/../core/theme/app_theme.dart';
import '/../core/config/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _checkAuthState(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    if (!context.mounted) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (context.mounted) {
        Navigator.pushReplacementNamed(
          context,
          user != null ? AppRoutes.main : AppRoutes.login,
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _checkAuthState(context));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.currency_bitcoin,
              size: 80,
              color: AppColors.accent,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}
