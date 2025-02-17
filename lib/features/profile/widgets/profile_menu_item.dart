import 'package:flutter/material.dart';
import 'package:kointos/core/theme/app_theme.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final bool showDivider;
  final Widget? trailing;

  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.color,
    this.showDivider = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: color ?? AppColors.text,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: color ?? AppColors.text,
              fontSize: 16,
            ),
          ),
          trailing: trailing ??
              const Icon(
                Icons.chevron_right,
                color: AppColors.text,
              ),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            color: AppColors.text.withAlpha(26),
            height: 1,
          ),
      ],
    );
  }
}
