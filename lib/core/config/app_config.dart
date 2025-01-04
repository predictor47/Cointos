class AppConfig {
  static const String appName = 'Crypto Tracker';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String coingeckoBaseUrl = 'https://api.coingecko.com/api/v3';
  static const int apiRequestTimeout = 30000; // 30 seconds
  
  // Cache Configuration
  static const int cacheDuration = 300; // 5 minutes
  
  // Portfolio Configuration
  static const int maxPortfolioItems = 100;
  static const int priceUpdateInterval = 30; // seconds
  
  // Rewards Configuration
  static const int dailySpinLimit = 3;
  static const int articleReadPoints = 5;
  static const int spinWheelBasePoints = 10;
  
  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const int chartDataPoints = 100;
} 