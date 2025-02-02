import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/notifications/models/notification_item.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  NotificationService();

  Future<void> initialize() async {
    try {
      if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
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
    } catch (e) {
      debugPrint('Error initializing notification service: $e');
    }
  }

  Future<void> _saveToken(String token) async {
    try {
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
    } catch (e) {
      debugPrint('Error saving notification token: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    try {
      debugPrint('Received foreground message: ${message.notification?.title}');
      _saveNotification(message);
      _showLocalNotification(message);
    } catch (e) {
      debugPrint('Error handling foreground message: $e');
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    try {
      debugPrint('Received background message: ${message.notification?.title}');
      _saveNotification(message);
    } catch (e) {
      debugPrint('Error handling background message: $e');
    }
  }

  Future<void> _saveNotification(RemoteMessage message) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final notification = NotificationItem(
        id: message.messageId ?? '',
        title: message.notification?.title ?? '',
        message: message.notification?.body ?? '',
        type: message.data['type'] as String,
        timestamp: DateTime.now(),
        read: false,
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .add(notification.toJson());
    } catch (e) {
      // Log the error or handle it accordingly
      if (kDebugMode) {
        print('Error saving notification: $e');
      }
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    // Implement local notification display
  }

  Future<List<NotificationItem>> getNotifications(
      {bool unreadOnly = false}) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    try {
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
    } catch (e) {
      // Log the error or handle it accordingly
      if (kDebugMode) {
        print('Error fetching notifications: $e');
      }
      return [];
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      if (kDebugMode) {
        print('Error marking notification as read: $e');
      }
    }
  }

  Future<void> markAllAsRead() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
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
    } catch (e) {
      if (kDebugMode) {
        print('Error marking all notifications as read: $e');
      }
    }
  }

  // ignore: unused_element
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (kDebugMode) {
      print('Handling a background message: ${message.messageId}');
    }
  }
}
