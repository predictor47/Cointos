import 'package:flutter/material.dart';
import 'package:crypto_tracker/core/constants/validation_rules.dart';
import 'package:crypto_tracker/core/widgets/custom_text_field.dart';

class AuthForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? usernameController;

  const AuthForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    this.usernameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (usernameController != null) ...[
          CustomTextField(
            label: 'Username',
            controller: usernameController!,
            prefixIcon: Icons.person,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter a username';
              }
              if (value!.length < ValidationRules.usernameMinLength) {
                return 'Username must be at least ${ValidationRules.usernameMinLength} characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
        ],
        CustomTextField(
          label: 'Email',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter your email';
            }
            if (!value!.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Password',
          controller: passwordController,
          isPassword: true,
          prefixIcon: Icons.lock,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter your password';
            }
            if (value!.length < ValidationRules.passwordMinLength) {
              return 'Password must be at least ${ValidationRules.passwordMinLength} characters';
            }
            return null;
          },
        ),
      ],
    );
  }
}