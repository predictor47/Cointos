import 'package:flutter/material.dart';
import 'package:your_app_name/core/theme/app_theme.dart';

class SwitchSettingItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;

  const SwitchSettingItem({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.text,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 16,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: AppColors.text.withAlpha(179),
                fontSize: 14,
              ),
            )
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.accent,
      ),
    );
  }
}
