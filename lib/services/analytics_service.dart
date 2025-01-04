class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  Future<void> logLogin({required String method}) async {
    await _analytics.logLogin(loginMethod: method);
  }

  Future<void> logSignUp({required String method}) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  Future<void> logPortfolioAction({
    required String action,
    required String coinId,
    double? amount,
  }) async {
    await _analytics.logEvent(
      name: 'portfolio_action',
      parameters: {
        'action': action,
        'coin_id': coinId,
        'amount': amount,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logSearch({required String searchTerm}) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  Future<void> logRewardClaimed({
    required String rewardType,
    required int points,
  }) async {
    await _analytics.logEvent(
      name: 'reward_claimed',
      parameters: {
        'reward_type': rewardType,
        'points': points,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logError({
    required String error,
    required String errorDetails,
  }) async {
    await _analytics.logEvent(
      name: 'app_error',
      parameters: {
        'error': error,
        'error_details': errorDetails,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> setUserProperties({
    String? userId,
    String? userRole,
    String? subscriptionTier,
  }) async {
    if (userId != null) {
      await _analytics.setUserId(id: userId);
    }
    if (userRole != null) {
      await _analytics.setUserProperty(name: 'user_role', value: userRole);
    }
    if (subscriptionTier != null) {
      await _analytics.setUserProperty(
        name: 'subscription_tier',
        value: subscriptionTier,
      );
    }
  }
} 