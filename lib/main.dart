import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_app_name/core/config/routes.dart';
import 'package:your_app_name/core/di/service_locator.dart';
import 'package:your_app_name/core/theme/app_theme.dart';
import 'package:your_app_name/features/splash/screens/splash_screen.dart';
import 'package:your_app_name/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
