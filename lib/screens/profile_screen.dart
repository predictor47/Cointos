import 'package:flutter/material.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatelessWidget {
  final UserService _userService = UserService();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder(
        future: _loadUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final userData = snapshot.data as Map<String, String>;
            return ListView(
              children: [
                ListTile(title: Text('Name: ${userData['name']}')),
                ListTile(title: Text('Email: ${userData['email']}')),
                ListTile(title: Text('Phone: ${userData['phone']}')),
                ListTile(title: Text('User ID: ${userData['userId']}')),
                ListTile(title: Text('Points: ${userData['points']}')),
                ListTile(title: Text('Referral Code: ${userData['userId']}')),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<Map<String, String>> _loadUserData() async {
    try {
      return await _userService.getUserData();
    } catch (e) {
      print('Error loading user data: $e');
      // Return a map with error information or rethrow the exception
      return {'error': 'Failed to load user data'};
    }
  }
}
