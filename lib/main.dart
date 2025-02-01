import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/config/routes.dart';
import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/screens/splash_screen.dart';
import 'providers/settings_provider.dart';
import 'providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Ensure you have this file generated
import 'package:kointos/providers/portfolio_provider.dart'; // Import your PortfolioProvider
import 'package:kointos/providers/auth_provider.dart';
import 'package:kointos/features/main/screens/main_screen.dart'; // Import your main screen
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:kointos/data/repositories/crypto_repository.dart'; // Ensure you import the CryptoRepository
import 'package:kointos/data/repositories/user_repository.dart'; // Ensure you import the UserRepository
import 'package:kointos/services/analytics_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  final FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase Analytics
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  await setupServiceLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<SettingsProvider>()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (_) => PortfolioProvider(
            cryptoRepository:
                getIt<CryptoRepository>(), // Pass the required argument
            userRepository:
                getIt<UserRepository>(), // Pass the required argument
            analytics: getIt<AnalyticsService>(), // Pass the required argument
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Kointos',
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
        routes: AppRoutes.routes,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<SettingsProvider>()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (_) => PortfolioProvider(
            cryptoRepository:
                getIt<CryptoRepository>(), // Pass the required argument
            userRepository:
                getIt<UserRepository>(), // Pass the required argument
            analytics: getIt<AnalyticsService>(), // Pass the required argument
          ),
        ),
        // Add other providers here
        // Add more providers as needed
      ],
      child: MaterialApp(
        title: 'Kointos',
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
        routes: AppRoutes.routes,
      ),
    );
  }
}
