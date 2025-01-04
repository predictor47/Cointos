class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            'General',
            [
              SwitchSettingItem(
                title: 'Dark Mode',
                icon: Icons.dark_mode,
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  // TODO: Implement theme switching
                },
              ),
              DropdownSettingItem(
                title: 'Currency',
                icon: Icons.currency_exchange,
                value: 'USD',
                items: const ['USD', 'EUR', 'GBP', 'JPY'],
                onChanged: (value) {
                  // TODO: Implement currency switching
                },
              ),
            ],
          ),
          _buildSection(
            'Notifications',
            [
              SwitchSettingItem(
                title: 'Price Alerts',
                icon: Icons.notifications,
                value: true,
                onChanged: (value) {
                  // TODO: Implement notification settings
                },
              ),
              SwitchSettingItem(
                title: 'News Updates',
                icon: Icons.newspaper,
                value: true,
                onChanged: (value) {
                  // TODO: Implement news notification settings
                },
              ),
            ],
          ),
          _buildSection(
            'Security',
            [
              ProfileMenuItem(
                title: 'Change Password',
                icon: Icons.lock,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.changePassword,
                ),
              ),
              SwitchSettingItem(
                title: 'Biometric Authentication',
                icon: Icons.fingerprint,
                value: false,
                onChanged: (value) {
                  // TODO: Implement biometric auth
                },
              ),
            ],
          ),
          _buildSection(
            'About',
            [
              ProfileMenuItem(
                title: 'Privacy Policy',
                icon: Icons.privacy_tip,
                onTap: () {
                  // TODO: Open privacy policy
                },
              ),
              ProfileMenuItem(
                title: 'Terms of Service',
                icon: Icons.description,
                onTap: () {
                  // TODO: Open terms of service
                },
              ),
              ProfileMenuItem(
                title: 'App Version',
                icon: Icons.info,
                trailing: Text(
                  AppConfig.appVersion,
                  style: TextStyle(
                    color: AppColors.text.withOpacity(0.7),
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }
} 