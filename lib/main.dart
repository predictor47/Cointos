import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; 
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/home_screen.dart'; 
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( 

    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp()); 

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(), 

      child: MaterialApp(
        title: 
 'Cointos',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          // ... other theme customizations
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blue,
          // ... other dark theme customizations
        ),
        themeMode: ThemeMode.system, 
        home: Consumer<AuthProvider>( 
          builder: (context, authProvider, child) {
            if (authProvider.isLoading) {
              return LoadingScreen(); 
            } else if (authProvider.user != null) {
              return HomeScreen(); 
            } else {
              return LoginScreen(); 
            }
          },
        ),
      ),
    );
  }
}