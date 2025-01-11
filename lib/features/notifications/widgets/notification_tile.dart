import 'package:flutter/material.dart';
import 'package:your_app_name/core/theme/app_theme.dart';
import 'package:your_app_name/features/notifications/models/notification_item.dart';

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: notification.read ? AppColors.surface : AppColors.accent,
        child: Icon(
          _getNotificationIcon(),
          color: notification.read ? AppColors.text : AppColors.background,
        ),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          color: AppColors.text,
          fontWeight: notification.read ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Text(
        notification.message,
        style: TextStyle(
          color: AppColors.text.withAlpha(179),
        ),
      ),
      trailing: Text(
        _getTimeAgo(),
        style: TextStyle(
          color: AppColors.text.withAlpha(179),
          fontSize: 12,
        ),
      ),
    );
  }

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case 'reward':
        return Icons.stars;
      case 'price_alert':
        return Icons.trending_up;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  String _getTimeAgo() {
    final difference = DateTime.now().difference(notification.timestamp);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
} 