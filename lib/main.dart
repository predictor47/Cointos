import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/config/routes.dart';
import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/screens/splash_screen.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/portfolio_provider.dart';
import 'providers/rewards_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/user_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'data/repositories/crypto_repository.dart';
import 'data/repositories/user_repository.dart';
import 'services/analytics_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setupServiceLocator();

  // Initialize analytics
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  getIt<AnalyticsService>().initialize(analytics);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<SettingsProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<UserProvider>()),
        ChangeNotifierProvider(
          create: (_) => getIt<PortfolioProvider>(),
        ),
        ChangeNotifierProvider(create: (_) => getIt<RewardsProvider>()),
      ],
      child: MaterialApp(
        title: 'Kointos',
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
        routes: AppRoutes.routes,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
      ),
    ),
  );
}
