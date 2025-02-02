import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kointos/core/config/app_config.dart';
import 'package:kointos/core/config/routes.dart';
import 'package:kointos/core/theme/app_theme.dart';
import 'package:kointos/data/models/user.dart';
import 'package:kointos/providers/rewards_provider.dart';
import 'package:kointos/data/repositories/user_repository.dart';
import 'package:kointos/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<void> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = _loadArticlesCount();
  }

  Future<void> _loadArticlesCount() async {
    final userRepo = context.read<UserRepository>();
    await userRepo.fetchArticlesReadCount();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final rewards = context.watch<RewardsProvider>();

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please login to view your profile'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        children: [
          _buildProfileHeader(user),
          const SizedBox(height: 24),
          _buildStatsSection(context, rewards),
          const SizedBox(height: 24),
          _buildMenuSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: user.profileImage.isNotEmpty
              ? NetworkImage(user.profileImage)
              : null,
          child: user.profileImage.isEmpty
              ? Text(
                  user.username[0].toUpperCase(),
                  style: const TextStyle(fontSize: 32),
                )
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          user.username,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        Text(
          user.email,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.text.withAlpha(179),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, RewardsProvider rewards) {
    final userRepo = context.watch<UserRepository>();

    return Row(
      children: [
        _buildStatCard(
          'Total Points',
          '${rewards.totalPoints}',
          Icons.stars,
        ),
        const SizedBox(width: 16),
        FutureBuilder(
          future: _articlesFuture,
          builder: (context, snapshot) {
            return _buildStatCard(
              'Articles Read',
              snapshot.connectionState == ConnectionState.waiting
                  ? '...'
                  : '${userRepo.articlesReadCount}',
              Icons.article,
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.accent),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: AppColors.text.withAlpha(179),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 16),
        _buildMenuItem(
          'Edit Profile',
          Icons.edit,
          () => Navigator.pushNamed(context, AppRoutes.editProfile),
        ),
        _buildMenuItem(
          'Notification Settings',
          Icons.notifications,
          () => Navigator.pushNamed(context, AppRoutes.notifications),
        ),
        _buildMenuItem(
          'Change Password',
          Icons.lock,
          () => Navigator.pushNamed(context, AppRoutes.changePassword),
        ),
        _buildMenuItem(
          'Logout',
          Icons.logout,
          () => _showLogoutDialog(context),
          color: AppColors.error,
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    String title,
    IconData icon,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.text),
      title: Text(
        title,
        style: TextStyle(color: color ?? AppColors.text),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.text,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pop(context);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
