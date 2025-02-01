import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:kointos/core/config/app_config.dart';
import 'package:kointos/core/constants/app_constants.dart';
import 'package:kointos/core/utils/error_handler.dart';
import 'package:kointos/data/models/user.dart';
import 'package:kointos/features/notifications/models/notification_item.dart';
import 'package:kointos/services/analytics_service.dart';

class UserRepository extends ChangeNotifier {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final AnalyticsService analytics;

  bool _hasUnreadNotifications = false;
  StreamSubscription? _notificationsSubscription;

  int _articlesReadCount = 0;
  int get articlesReadCount => _articlesReadCount;

  bool get hasUnreadNotifications => _hasUnreadNotifications;

  UserRepository({
    required this.firestore,
    required this.storage,
    required this.analytics,
  }) {
    _initializeNotifications();
  }

  void _initializeNotifications() {
    final userId = auth.FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    _notificationsSubscription = firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('read', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      _hasUnreadNotifications = snapshot.docs.isNotEmpty;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _notificationsSubscription?.cancel();
    super.dispose();
  }

  Future<User> getUser(String userId) async {
    try {
      final doc = await firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .get();

      if (!doc.exists) {
        throw AppError('User not found', ErrorType.authentication);
      }

      return User.fromJson(doc.data()!);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await firestore
          .collection(FirestoreCollections.users)
          .doc(user.id)
          .update(user.toJson());
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updatePoints(String userId, int points) async {
    try {
      await firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .update({
        'totalPoints': FieldValue.increment(points),
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> canSpin(String userId) async {
    try {
      final user = await getUser(userId);
      final now = DateTime.now();

      if (user.lastSpinTime.day != now.day) {
        await firestore
            .collection(FirestoreCollections.users)
            .doc(userId)
            .update({
          'dailySpins': 0,
        });
        return true;
      }

      return user.dailySpins < AppConfig.dailySpinLimit;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> recordSpin(String userId, int points) async {
    try {
      await firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .update({
        'dailySpins': FieldValue.increment(1),
        'lastSpinTime': Timestamp.now(),
        'totalPoints': FieldValue.increment(points),
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    final userId = auth.FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final batch = firestore.batch();
    final unreadDocs = await firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('read', isEqualTo: false)
        .get();

    for (var doc in unreadDocs.docs) {
      batch.update(doc.reference, {'read': true});
    }

    await batch.commit();
    _hasUnreadNotifications = false;
    notifyListeners();
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final userId = auth.FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'read': true});
  }

  Future<List<NotificationItem>> getNotifications(
      {bool unreadOnly = false}) async {
    final userId = auth.FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    var query = firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true);

    if (unreadOnly) {
      query = query.where('read', isEqualTo: false);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => NotificationItem.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<void> fetchArticlesReadCount() async {
    final snapshot = await firestore
        .collection('users')
        .doc(auth.FirebaseAuth.instance.currentUser?.uid)
        .collection('readArticles')
        .get();
    _articlesReadCount = snapshot.docs.length;
    notifyListeners();
  }

  Future<User> fetchUserData() async {
    final userId = auth.FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final doc = await firestore.collection('users').doc(userId).get();
    if (!doc.exists) throw Exception('User not found');

    return User.fromJson(doc.data()!);
  }

  AppError _handleError(dynamic error) {
    if (error is FirebaseException) {
      return AppError(
          error.message ?? ErrorMessages.serverError, ErrorType.server);
    }
    if (error is AppError) {
      return error;
    }
    return AppError(ErrorMessages.unknownError, ErrorType.unknown);
  }
}
