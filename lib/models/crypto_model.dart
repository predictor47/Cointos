class Crypto {
  final String id;
  final String name;
  final String symbol;
  final String image;
  final double currentPrice;
  final double? marketCap;
  final double? high24h;
  final double? low24h;
  final double? priceChangePercentage24h;
  double holdings;

  Crypto({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.currentPrice,
    this.marketCap,
    this.high24h,
    this.low24h,
    this.priceChangePercentage24h,
    this.holdings = 0,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      image: json['image'],
      currentPrice: json['current_price'].toDouble(),
      marketCap: json['market_cap']?.toDouble(),
      high24h: json['high_24h']?.toDouble(),
      low24h: json['low_24h']?.toDouble(),
      priceChangePercentage24h: json['price_change_percentage_24h']?.toDouble(),
    );
  }
}
