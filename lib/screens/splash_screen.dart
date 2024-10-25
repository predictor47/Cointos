import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  Future<void> _checkUserAndNavigate() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simulating some loading time

    if (mounted) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Designer.png', // Make sure this path is correct
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
            ),
          ],
        ),
      ),
    );
  }
}
