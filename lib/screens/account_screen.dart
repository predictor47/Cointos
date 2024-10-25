import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const Divider(),
            _buildRewardsSection(),
            const Divider(),
            _buildSettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/profile_placeholder.png'),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('John Doe',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  Text('john.doe@example.com',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Implement edit profile functionality
            },
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rewards',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRewardCard('Current Points', '1,250'),
              _buildRewardCard('Lifetime Points', '5,000'),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Implement redeem rewards functionality
            },
            child: const Text('Redeem Rewards'),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(String title, String points) {
    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(points,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.white),
            title: const Text('Notifications',
                style: TextStyle(color: Colors.white)),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // Implement notification settings
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.security, color: Colors.white),
            title:
                const Text('Security', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Navigate to security settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.white),
            title: const Text('Help & Support',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              // Navigate to help and support
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text('Log Out', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Implement log out functionality
            },
          ),
        ],
      ),
    );
  }
}
