import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  late final FirebaseAnalytics _analytics;

  void initialize(FirebaseAnalytics analytics) {
    _analytics = analytics;
  }

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters:
          parameters?.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }
}
