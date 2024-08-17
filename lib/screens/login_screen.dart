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

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cointos Login'),
      ),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColorLight,
                Theme.of(context).primaryColorDark,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
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
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: () async {
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
                              content: Row(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(width: 16),
                                  Text('Logging in...'),
                                ],
                              ),
                            ),
                          );
                        } else {
                          Navigator.pop(context);

                          if (authProvider.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(authProvider.errorMessage!)),
                            );

                            if (authProvider.errorMessage ==
                                'No user found for that email.') {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('User Not Found'),
                                  content: Text(
                                      'Would you like to register a new account?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignupScreen()),
                                        );
                                      },
                                      child: Text('Yes, Register'),
                                    ),
                                  ],
                                ),
                              );
                            } else if (authProvider.errorMessage ==
                                'Wrong password provided for that user.') {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Incorrect Password'),
                                  content: Text(
                                      'Would you like to reset your password?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotPasswordScreen()),
                                        );
                                      },
                                      child: Text('Yes, Reset Password'),
                                    ),
                                  ],
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Login'),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen()),
                      );
                    },
                    child: Text('Forgot Password?'),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text("Don't have an account? Sign Up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
