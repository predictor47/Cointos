import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import '../services/user_service.dart';
import '../theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final UserService _userService = UserService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UpgradedAppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: UpgradedAppTheme.appBarTheme,
        title: Text(
          'Cointos Signup',
          style: TextStyle(
            color: UpgradedAppTheme.textColor,
            fontFamily: UpgradedAppTheme.fontFamily,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _emailController,
                hintText: 'Email',
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
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                hintText: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                hintText: 'Phone',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await _userService.signUp(
                        email: _emailController.text,
                        password: _passwordController.text,
                        name: _nameController.text,
                        phone: _phoneController.text,
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Signup failed: $e'),
                          backgroundColor: UpgradedAppTheme.errorColor,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: UpgradedAppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontFamily: UpgradedAppTheme.fontFamily,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: UpgradedAppTheme.primaryColor,
                ),
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(
                    fontFamily: UpgradedAppTheme.fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: UpgradedAppTheme.textColor,
        fontFamily: UpgradedAppTheme.fontFamily,
      ),
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: UpgradedAppTheme.hintTextStyle,
        filled: true,
        fillColor: UpgradedAppTheme.inputFieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}
