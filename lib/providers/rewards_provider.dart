import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/repositories/user_repository.dart';
import '../services/analytics_service.dart';
import '../services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' show DateUtils;

class RewardsProvider extends ChangeNotifier {
  final UserRepository userRepository;
  final AnalyticsService analytics;
  final FirebaseService _firebaseService = FirebaseService();

  RewardsProvider({
    required this.userRepository,
    required this.analytics,
  }) {
    _initializePoints();
    _checkDailyRewards();
  }

  int _totalPoints = 0;
  int _availableRewards = 0;
  bool _canClaimDailyReward = false;
  DateTime? _lastRewardClaim;
  StreamSubscription? _pointsSubscription;

  int get totalPoints => _totalPoints;
  int get availableRewards => _availableRewards;
  bool get hasAvailableRewards => _availableRewards > 0;
  bool get canClaimDailyReward => _canClaimDailyReward;

  void _initializePoints() {
    _pointsSubscription = _firebaseService.streamTotalPoints().listen(
      (points) {
        _totalPoints = points;
        _availableRewards = _calculateAvailableRewards();
        notifyListeners();
      },
      onError: (error) {
        if (kDebugMode) {
          print('Error streaming points: $error');
        }
      },
    );
  }

  Future<void> _checkDailyRewards() async {
    try {
      final userData = await _firebaseService.getUserDocument().get();
      if (!userData.exists) return;
      final data = userData.data() as Map<String, dynamic>?;
      _lastRewardClaim = (data?['lastRewardClaim'] as Timestamp?)?.toDate();
      _canClaimDailyReward = _canClaimDaily();
      if (_canClaimDailyReward) _availableRewards++;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error checking daily rewards: $e');
      }
    }
  }

  bool _canClaimDaily() {
    if (_lastRewardClaim == null) return true;

    final now = DateTime.now();
    final lastClaim = _lastRewardClaim!;

    return !DateUtils.isSameDay(now, lastClaim);
  }

  int _calculateAvailableRewards() {
    int count = 0;
    if (_canClaimDailyReward) count++;
    return count;
  }

  Future<void> claimDailyReward() async {
    if (!_canClaimDailyReward) return;

    try {
      await _firebaseService.addRewardPoints(100, 'Daily Reward');
      await _firebaseService.updateUserData({
        'lastRewardClaim': Timestamp.now(),
      });

      _lastRewardClaim = DateTime.now();
      _canClaimDailyReward = false;
      _availableRewards--;

      analytics.logEvent(
        name: 'claim_daily_reward',
        parameters: {'points': 100},
      );

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error claiming daily reward: $e');
      }
      rethrow;
    }
  }

  @override
  void dispose() {
    _pointsSubscription?.cancel();
    super.dispose();
  }

  Future<void> addPoints(int points, String source) async {
    await _firebaseService.addRewardPoints(points, source);
  }

  Future<List<Map<String, dynamic>>> getRewardHistory() async {
    return _firebaseService.getRewardHistory();
  }

  Future<void> markArticleAsRead(String articleId) async {
    await _firebaseService.markArticleAsRead(articleId);
  }

  Future<bool> hasReadArticle(String articleId) async {
    return _firebaseService.hasReadArticle(articleId);
  }

  Future<void> fetchRewards() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final doc = await _firebaseService.getUserDocument().get();
      final data = doc.data() as Map<String, dynamic>?;

      if (doc.exists) {
        _totalPoints = data?['totalPoints'] ?? 0;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching rewards: $e');
      }
    }
  }

  Future<bool> canSpin() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return false;

    try {
      final canSpin = await userRepository.canSpin(userId);
      if (canSpin) {
        analytics.logEvent(name: 'can_spin_wheel');
      }
      return canSpin;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking spin eligibility: $e');
      }
      return false;
    }
  }

  Future<void> recordSpin({required int points}) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await userRepository.recordSpin(userId, points);
  }
}
