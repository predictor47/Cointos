import 'package:flutter/material.dart';
import 'package:kointos/features/auth/screens/forgot_password_screen.dart';
import 'package:kointos/features/auth/screens/login_screen.dart';
import 'package:kointos/features/auth/screens/register_screen.dart';
import 'package:kointos/features/home/screens/home_screen.dart';
import 'package:kointos/features/portfolio/screens/portfolio_screen.dart';
import 'package:kointos/features/rewards/screens/spin_wheel_screen.dart';
import 'package:kointos/features/auth/screens/change_password_screen.dart';
import 'package:kointos/features/splash/screens/splash_screen.dart';
import 'package:kointos/features/main/screens/main_screen.dart';
import 'package:kointos/features/settings/screens/settings_screen.dart';
import 'package:kointos/features/notifications/screens/notifications_screen.dart';
import 'package:kointos/features/profile/screens/edit_profile_screen.dart';
import 'package:kointos/features/crypto/screens/crypto_detail_screen.dart';
import 'package:kointos/models/crypto_model.dart';

class AppRoutes {
  static const String login = '/login';
  static const String main = '/main';
  static const String forgotPassword = '/forgot-password';
  static const String register = '/register';
  static const String portfolio = '/portfolio';
  static const String rewards = '/rewards';
  static const String cryptoDetail = '/crypto'; // Base path for crypto detail
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';
  static const String security = '/security';
  static const String support = '/support';
  static const String spinWheel = '/spin-wheel';
  static const String changePassword = '/change-password';
  static const String error = '/error';

  // Static routes map for MaterialApp
  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    main: (context) => const MainScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    register: (context) => const RegisterScreen(),
    portfolio: (context) => const PortfolioScreen(),
    spinWheel: (context) => const SpinWheelScreen(),
    changePassword: (context) => const ChangePasswordScreen(),
    settings: (context) => const SettingsScreen(),
    notifications: (context) => const NotificationsScreen(),
    editProfile: (context) => const EditProfileScreen(),
  };

  // Function to generate crypto detail route
  static String cryptoDetailRoute(Crypto crypto) =>
      '$cryptoDetail/${crypto.id}';

  // Dynamic route generation for routes that need parameters
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Extract the route path and arguments
    final uri = Uri.parse(settings.name ?? '');
    final args = settings.arguments;

    // Handle crypto detail route
    if (uri.path.startsWith('$cryptoDetail/')) {
      if (args is! Crypto) {
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        );
      }
      return MaterialPageRoute(
        builder: (_) => CryptoDetailScreen(crypto: args),
        settings: settings,
      );
    }

    // Return null to let the MaterialApp handle static routes
    return null;
  }
}
