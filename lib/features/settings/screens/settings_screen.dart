import 'package:flutter/material.dart';
import 'package:kointos/core/config/app_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kointos/core/config/routes.dart';
import 'package:kointos/core/theme/app_theme.dart';
import 'package:kointos/features/profile/widgets/profile_menu_item.dart';
import 'package:kointos/features/settings/widgets/dropdown_setting_item.dart';
import 'package:kointos/features/settings/widgets/switch_setting_item.dart';
import 'package:provider/provider.dart';
import 'package:kointos/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                  context.read<SettingsProvider>().toggleTheme();
                },
              ),
              DropdownSettingItem(
                title: 'Currency',
                icon: Icons.currency_exchange,
                value: 'USD',
                items: const ['USD', 'EUR', 'GBP', 'JPY'],
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsProvider>().setCurrency(value);
                  }
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
                value: context.watch<SettingsProvider>().priceAlerts,
                onChanged: (value) =>
                    context.read<SettingsProvider>().setPriceAlerts(value),
              ),
              SwitchSettingItem(
                title: 'News Updates',
                icon: Icons.newspaper,
                value: context.watch<SettingsProvider>().newsUpdates,
                onChanged: (value) =>
                    context.read<SettingsProvider>().setNewsUpdates(value),
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
                value: context.watch<SettingsProvider>().biometricEnabled,
                onChanged: (value) =>
                    context.read<SettingsProvider>().setBiometricEnabled(value),
              ),
            ],
          ),
          _buildSection(
            'About',
            [
              ProfileMenuItem(
                title: 'Privacy Policy',
                icon: Icons.privacy_tip,
                onTap: () async {
                  final Uri url = Uri.parse(AppConfig.privacyPolicyUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              ProfileMenuItem(
                title: 'Terms of Service',
                icon: Icons.description,
                onTap: () async {
                  final Uri url = Uri.parse(AppConfig.termsOfServiceUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              ProfileMenuItem(
                title: 'App Version',
                icon: Icons.info,
                trailing: Text(
                  AppConfig.appVersion,
                  style: TextStyle(
                    color: AppColors.text.withAlpha(179),
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
