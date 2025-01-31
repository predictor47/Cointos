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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Ensure this is correct
  );
  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<SettingsProvider>()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // Other providers...
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
