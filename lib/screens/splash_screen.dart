import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        // Check last login time
        final prefs = await SharedPreferences.getInstance();
        final lastLoginTime = prefs.getInt('lastLoginTime') ?? 0;
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        const oneWeekInMillis =
            7 * 24 * 60 * 60 * 1000; // One week in milliseconds

        if (currentTime - lastLoginTime > oneWeekInMillis) {
          // If more than a week has passed, log out and go to login screen
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        } else {
          // If less than a week, go to home screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Designer.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 24),
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
