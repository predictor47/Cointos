class StorageKeys {
  static const String authToken = 'auth_token';
  static const String userId = 'user_id';
  static const String theme = 'app_theme';
  static const String currency = 'preferred_currency';
  static const String lastSpinTime = 'last_spin_time';
  static const String spinCount = 'daily_spin_count';
}

class FirestoreCollections {
  static const String users = 'users';
  static const String portfolio = 'portfolio';
  static const String rewards = 'rewards';
  static const String articles = 'articles';
  static const String readArticles = 'readArticles';
}

class ErrorMessages {
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Server error occurred';
  static const String authError = 'Authentication failed';
  static const String unknownError = 'An unexpected error occurred';
  static const String invalidInput = 'Please check your input';
  static const String portfolioLimitReached = 'Portfolio limit reached';
  static const String duplicateCoin = 'Coin already exists in portfolio';
  static const String spinLimitReached = 'Daily spin limit reached';
}

class ValidationRules {
  static const double minAmount = 0.000001;
  static const double maxAmount = 1000000000;
  static const int passwordMinLength = 8;
  static const int usernameMinLength = 3;
} 