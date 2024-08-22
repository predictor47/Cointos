import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Error message variables
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
      duration: Duration(milliseconds: 800),
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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF0D1117),
      body: SingleChildScrollView(
        // Added for scroll prevention
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
                          Text(
                            'Welcome Back 👋',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 32.0),
                          TextFormField(
                            controller: _emailController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Color(0xFF8B949E)),
                              filled: true,
                              fillColor: Color(0xFF161B22),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              errorText: _emailError, // Display email error
                              errorStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 12, // Smaller error text
                              ),
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
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _passwordController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Color(0xFF8B949E)),
                              filled: true,
                              fillColor: Color(0xFF161B22),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              errorText:
                                  _passwordError, // Display password error
                              errorStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 12, // Smaller error text
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 32.0),
                          ElevatedButton(
                            onPressed: () async {
                              // Reset error messages
                              setState(() {
                                _emailError = null;
                                _passwordError = null;
                              });

                              if (_formKey.currentState!.validate()) {
                                await authProvider.login(
                                  _emailController.text,
                                  _passwordController.text,
                                );

                                if (authProvider.isLoading) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Color(0xFF161B22),
                                      content: Row(
                                        children: [
                                          CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Color(0xFF0D9488),
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Text(
                                            'Logging in...',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.pop(
                                      context); // Close loading dialog

                                  if (authProvider.errorMessage != null) {
                                    // Handle specific Firebase errors
                                    if (authProvider.errorMessage!
                                        .contains('user-not-found')) {
                                      setState(() {
                                        _emailError =
                                            'User not found. Sign up?';
                                      });
                                    } else if (authProvider.errorMessage!
                                        .contains('wrong-password')) {
                                      setState(() {
                                        _passwordError = 'Incorrect password';
                                      });
                                    } else {
                                      // Generic error handling
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Color(0xFF161B22),
                                          content: Text(
                                            authProvider.errorMessage!,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()),
                                    );
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Color(0xFF0D9488),
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Sign in'),
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordScreen()),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Color(0xFF0D9488),
                                ),
                                child: Text('Forgot Password?'),
                              ),
                            ],
                          ),
                          SizedBox(height: 32.0),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Implement Google sign-in logic here
                                },
                                icon: Icon(Icons.g_mobiledata),
                                label: Text('Google'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Color(0xFF0D9488),
                                  backgroundColor: Color(0xFF161B22),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 24.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.0),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Implement Facebook sign-in logic here
                                },
                                icon: Icon(Icons.facebook),
                                label: Text('Facebook'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Color(0xFF0D9488),
                                  backgroundColor: Color(0xFF161B22),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 24.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.0),

                              // Sign Up button
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupScreen()),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Color(0xFF0D9488),
                                ),
                                child: Text("Don't have an account? Sign Up"),
                              ),
                            ],
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
