import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:kointos/core/config/app_config.dart';
import 'package:kointos/core/constants/app_constants.dart';
import 'package:kointos/core/di/service_locator.dart';
import 'package:kointos/core/theme/app_theme.dart';
import 'package:kointos/core/utils/error_handler.dart';
import 'package:kointos/data/models/user.dart';
import 'package:kointos/data/repositories/user_repository.dart';
import 'package:kointos/providers/auth_provider.dart';
import 'package:kointos/shared/widgets/custom_button.dart';
import 'package:kointos/shared/widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      _usernameController.text = user.username;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() => _imageFile = File(image.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final userRepo = getIt<UserRepository>();
      final user = context.read<AuthProvider>().user;

      if (user == null) {
        throw Exception('No user logged in');
      }

      String? imageUrl;
      if (_imageFile != null) {
        try {
          imageUrl = await userRepo.uploadProfileImage(user.id, _imageFile!);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Failed to upload image: ${ErrorHandler.getMessage(e)}')),
            );
            return;
          }
        }
      }

      final updatedUser = user.copyWith(
        username: _usernameController.text.trim(),
        profileImage: imageUrl ?? user.profileImage,
      );

      await userRepo.updateUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandler.getMessage(e))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please login to edit your profile'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (user.profileImage.isNotEmpty
                            ? NetworkImage(user.profileImage)
                            : null) as ImageProvider?,
                    child: user.profileImage.isEmpty && _imageFile == null
                        ? Text(
                            user.username[0].toUpperCase(),
                            style: const TextStyle(fontSize: 40),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: AppColors.accent,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        color: AppColors.text,
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              CustomTextField(
                label: 'Username',
                controller: _usernameController,
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
              const SizedBox(height: 32),
              CustomButton(
                text: 'Save Changes',
                onPressed: _updateProfile,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
