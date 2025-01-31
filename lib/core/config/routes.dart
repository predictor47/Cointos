import 'package:flutter/material.dart';
import '/features/auth/screens/forgot_password_screen.dart';
import '/features/auth/screens/login_screen.dart';
import '/features/auth/screens/register_screen.dart';
import '/features/home/screens/home_screen.dart';
import '/features/portfolio/screens/portfolio_screen.dart';
import '/features/rewards/screens/spin_wheel_screen.dart';
import '/features/auth/screens/change_password_screen.dart';
import '/features/splash/screens/splash_screen.dart';
import '/features/main/screens/main_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String main = '/main';
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

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        login: (context) => const LoginScreen(),
        main: (context) => const MainScreen(),
        forgotPassword: (context) => const ForgotPasswordScreen(),
        register: (context) => const RegisterScreen(),
        portfolio: (context) => const PortfolioScreen(),
        spinWheel: (context) => const SpinWheelScreen(),
        changePassword: (context) => const ChangePasswordScreen(),
      };
}
