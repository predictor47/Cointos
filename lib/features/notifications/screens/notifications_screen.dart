import 'package:flutter/material.dart';
import 'package:your_app_name/core/config/routes.dart';
import 'package:your_app_name/core/theme/app_theme.dart';
import 'package:your_app_name/features/notifications/models/notification_item.dart';
import 'package:your_app_name/features/notifications/widgets/notification_tile.dart';
import 'package:your_app_name/data/repositories/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () async {
              final userRepo = context.read<UserRepository>();
              await userRepo.markAllNotificationsAsRead();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All notifications marked as read')),
                );
              }
            },
            child: const Text(
              'Mark all as read',
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Unread'),
              ],
              labelColor: AppColors.accent,
              unselectedLabelColor: AppColors.text.withAlpha(179),
              indicatorColor: AppColors.accent,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildNotificationsList(false),
                  _buildNotificationsList(true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList(bool unreadOnly) {
    return FutureBuilder<List<NotificationItem>>(
      future: _getNotifications(unreadOnly),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading notifications',
              style: TextStyle(color: AppColors.text.withAlpha(179)),
            ),
          );
        }

        final notifications = snapshot.data ?? [];
        if (notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 64,
                  color: AppColors.text.withAlpha(179),
                ),
                const SizedBox(height: 16),
                Text(
                  'No notifications',
                  style: TextStyle(
                    color: AppColors.text.withAlpha(179),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationTile(
              notification: notification,
              onTap: () async {
                final userRepo = context.read<UserRepository>();
                await userRepo.markNotificationAsRead(notification.id);
                
                // Handle navigation based on notification type
                if (notification.type == 'price_alert' && notification.data?['coinId'] != null) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.cryptoDetail,
                    arguments: notification.data!['coinId'],
                  );
                } else if (notification.type == 'reward') {
                  Navigator.pushNamed(context, AppRoutes.rewards);
                }
              },
            );
          },
        );
      },
    );
  }

  Future<List<NotificationItem>> _getNotifications(bool unreadOnly) async {
    final userRepo = GetIt.I<UserRepository>();
    return userRepo.getNotifications(unreadOnly: unreadOnly);
  }
} 