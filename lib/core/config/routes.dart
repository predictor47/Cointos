import 'package:flutter/material.dart';
import 'package:your_app_name/features/auth/screens/forgot_password_screen.dart';
import 'package:your_app_name/features/auth/screens/login_screen.dart';
import 'package:your_app_name/features/auth/screens/register_screen.dart';
import 'package:your_app_name/features/home/screens/home_screen.dart';
import 'package:your_app_name/features/portfolio/screens/portfolio_screen.dart';
import 'package:your_app_name/features/rewards/screens/spin_wheel_screen.dart';
import 'package:your_app_name/features/auth/screens/change_password_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String register = '/register';
  static const String portfolio = '/portfolio';
  static const String rewards = '/rewards';
  static const String cryptoDetail = '/crypto/:id';
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';
  static const String security = '/security';
  static const String support = '/support';
  static const String spinWheel = '/spin-wheel';
  static const String changePassword = '/change-password';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case portfolio:
        return MaterialPageRoute(builder: (_) => const PortfolioScreen());
      case spinWheel:
        return MaterialPageRoute(builder: (_) => const SpinWheelScreen());
      case changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      // Add other routes
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route ${settings.name} not found')),
          ),
        );
    }
  }
}
