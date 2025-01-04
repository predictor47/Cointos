import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: UpgradedAppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: UpgradedAppTheme.surfaceColor,
        title: Text(
          'Forgot Password',
          style: TextStyle(
            color: UpgradedAppTheme.accentColor,
            fontFamily: UpgradedAppTheme.fontFamily,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: UpgradedAppTheme.fontFamily,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: Colors.white70,
                      fontFamily: UpgradedAppTheme.fontFamily,
                    ),
                    filled: true,
                    fillColor: UpgradedAppTheme.surfaceColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
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
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await authProvider.forgotPassword(_emailController.text);

                      if (authProvider.isLoading) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            backgroundColor: UpgradedAppTheme.surfaceColor,
                            content: Row(
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    UpgradedAppTheme.accentColor,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Sending reset email...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: UpgradedAppTheme.fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        Navigator.pop(context);

                        if (authProvider.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: UpgradedAppTheme.errorColor,
                              content: Text(
                                authProvider.errorMessage!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: UpgradedAppTheme.fontFamily,
                                ),
                              ),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: UpgradedAppTheme.surfaceColor,
                              title: Text(
                                'Password Reset Email Sent',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: UpgradedAppTheme.fontFamily,
                                ),
                              ),
                              content: Text(
                                'Please check your inbox for instructions to reset your password.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: UpgradedAppTheme.fontFamily,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      color: UpgradedAppTheme.accentColor,
                                      fontFamily: UpgradedAppTheme.fontFamily,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: UpgradedAppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: UpgradedAppTheme.fontFamily,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Reset Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
