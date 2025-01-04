class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    final rewards = context.watch<RewardsProvider>();

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
          _buildStatsSection(rewards),
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
            color: AppColors.text.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(RewardsProvider rewards) {
    return Row(
      children: [
        _buildStatCard(
          'Total Points',
          '${rewards.totalPoints}',
          Icons.stars,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Articles Read',
          '0', // TODO: Implement article tracking
          Icons.article,
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
                color: AppColors.text.withOpacity(0.7),
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
          'Security',
          Icons.security,
          () => Navigator.pushNamed(context, AppRoutes.security),
        ),
        _buildMenuItem(
          'Help & Support',
          Icons.help,
          () => Navigator.pushNamed(context, AppRoutes.support),
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
              getIt<AuthRepository>().signOut();
              Navigator.pop(context);
            },
            child: Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
} 