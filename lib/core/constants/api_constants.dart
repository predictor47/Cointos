class ApiEndpoints {
  static const String coins = '/coins';
  static const String markets = '/coins/markets';
  static const String search = '/search';
  static const String trending = '/search/trending';

  // Coin specific endpoints
  static String coinDetail(String id) => '/coins/$id';
  static String coinMarketChart(String id) => '/coins/$id/market_chart';
  static String coinOhlc(String id) => '/coins/$id/ohlc';
}

class ApiParameters {
  static const String vsCurrency = 'vs_currency';
  static const String ids = 'ids';
  static const String order = 'order';
  static const String perPage = 'per_page';
  static const String page = 'page';
  static const String sparkline = 'sparkline';
  static const String priceChangePercentage = 'price_change_percentage';
  static const String days = 'days';
  static const String interval = 'interval';
}

class ApiDefaults {
  static const String defaultCurrency = 'usd';
  static const String defaultOrder = 'market_cap_desc';
  static const int defaultPerPage = 100;
  static const int defaultPage = 1;
}

class ApiConstants {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';

  // Add other API-related constants here
}
