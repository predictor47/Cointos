import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Cointos',
        theme: UpgradedAppTheme.lightTheme, // Use the light theme
        darkTheme: UpgradedAppTheme.darkTheme, // Use the dark theme
        themeMode: ThemeMode.system, // Follow system theme
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false, // Remove debug banner
        routes: {
          // Add custom routes for your screens
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => ProfileScreen(),
        },
        navigatorObservers: [
          // Add custom navigator observers to track navigation
          RouteObserver<PageRoute>(),
        ],
      ),
    );
  }
}
