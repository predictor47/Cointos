class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Implement mark all as read
            },
            child: Text(
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
              unselectedLabelColor: AppColors.text.withOpacity(0.7),
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
              style: TextStyle(color: AppColors.text.withOpacity(0.7)),
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
                  color: AppColors.text.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No notifications',
                  style: TextStyle(
                    color: AppColors.text.withOpacity(0.7),
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
              onTap: () {
                // TODO: Handle notification tap
              },
            );
          },
        );
      },
    );
  }

  Future<List<NotificationItem>> _getNotifications(bool unreadOnly) async {
    // TODO: Implement notification fetching
    return [];
  }
} 