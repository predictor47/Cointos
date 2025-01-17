import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_app_name/features/notifications/models/notification_item.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  NotificationService();

  Future<void> initialize() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await _messaging.getToken();
      if (token != null) {
        await _saveToken(token);
      }

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    }
  }

  Future<void> _saveToken(String token) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('tokens')
          .doc('latest')
          .set({
        'token': token,
        'platform': Platform.operatingSystem,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Handle foreground message
    _saveNotification(message);
    _showLocalNotification(message);
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    // Handle background message
    _saveNotification(message);
  }

  Future<void> _saveNotification(RemoteMessage message) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final notification = NotificationItem(
      id: message.messageId ?? DateTime.now().toString(),
      title: message.notification?.title ?? '',
      message: message.notification?.body ?? '',
      type:
          _getNotificationType(message.data['type']).toString().split('.').last,
      timestamp: DateTime.now(),
      data: message.data,
    );

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notification.id)
        .set(notification.toJson());
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    // Implement local notification display
  }

  NotificationType _getNotificationType(String? type) {
    switch (type) {
      case 'price_alert':
        return NotificationType.priceAlert;
      case 'news':
        return NotificationType.news;
      case 'reward':
        return NotificationType.reward;
      default:
        return NotificationType.system;
    }
  }

  Future<List<NotificationItem>> getNotifications(
      {bool unreadOnly = false}) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    Query query = _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true);

    if (unreadOnly) {
      query = query.where('isRead', isEqualTo: false);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) =>
            NotificationItem.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> markAsRead(String notificationId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  Future<void> markAllAsRead() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final batch = _firestore.batch();
    final notifications = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in notifications.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }
}
