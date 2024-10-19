import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogin(AuthProvider authProvider) async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    if (_formKey.currentState!.validate()) {
      try {
        await authProvider.login(
          _emailController.text,
          _passwordController.text,
        );

        // Navigate to HomeScreen on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'user-not-found':
            setState(() {
              _emailError = 'No account found for this email.';
            });
            _showErrorDialog(
              'Account Not Found',
              'Would you like to create an account?',
            );
            break;
          case 'wrong-password':
            setState(() {
              _passwordError = 'Incorrect password.';
            });
            break;
          case 'invalid-email':
            setState(() {
              _emailError = 'Invalid email address.';
            });
            break;
          case 'user-disabled':
            _showErrorDialog('Account Disabled',
                'Your account has been disabled. Please contact support.');
            break;
          default:
            _showErrorDialog('Login Error', 'An unexpected error occurred.');
        }
      } catch (e) {
        _showErrorDialog('Error', 'An unexpected error occurred.');
      }
    }
  }

  Future<void> _handleGoogleSignIn(AuthProvider authProvider) async {
    try {
      UserCredential? userCredential = await authProvider.signInWithGoogle();
      if (userCredential != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'An account already exists with this email.';
          break;
        case 'invalid-credential':
          errorMessage = 'The credential is invalid or has expired.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Google sign-in is not enabled for this project.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found for this email.';
          break;
        default:
          errorMessage = 'An unexpected error occurred.';
      }
      _showErrorDialog('Google Sign-In Error', errorMessage);
    } catch (e) {
      _showErrorDialog(
          'Error', 'An unexpected error occurred during Google sign-in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SingleChildScrollView(
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value * 50),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Welcome Back 👋',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle:
                                  const TextStyle(color: Color(0xFF8B949E)),
                              filled: true,
                              fillColor: const Color(0xFF161B22),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              errorText: _emailError,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _passwordController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle:
                                  const TextStyle(color: Color(0xFF8B949E)),
                              filled: true,
                              fillColor: const Color(0xFF161B22),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              errorText: _passwordError,
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32.0),
                          ElevatedButton(
                            onPressed: () => _handleLogin(authProvider),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF0D9488),
                              backgroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text('Sign in'),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordScreen()),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF0D9488),
                                ),
                                child: const Text('Forgot Password?'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32.0),
                          ElevatedButton.icon(
                            onPressed: () => _handleGoogleSignIn(authProvider),
                            icon: const Icon(Icons.g_mobiledata),
                            label: const Text('Sign in with Google'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF0D9488),
                              backgroundColor: const Color(0xFF161B22),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupScreen()),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF0D9488),
                            ),
                            child: const Text("Don't have an account? Sign Up"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
