class Crypto {
  final String id;
  final String symbol;
  final String name;
  final double currentPrice;
  final double priceChangePercentage24h;
  final String image;
  final List<double> sparklineData;
  final String category;
  final double marketCap;
  final double high24h;
  final double low24h;
  final double totalVolume;

  Crypto({
    required this.id,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.image,
    required this.sparklineData,
    required this.category,
    required this.marketCap,
    required this.high24h,
    required this.low24h,
    required this.totalVolume,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      currentPrice: (json['current_price'] as num).toDouble(),
      priceChangePercentage24h:
          (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] as String,
      sparklineData: (json['sparkline_in_7d']?['price'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      category: json['category'] as String? ?? 'All',
      marketCap: (json['market_cap'] as num).toDouble(),
      high24h: (json['high_24h'] as num).toDouble(),
      low24h: (json['low_24h'] as num).toDouble(),
      totalVolume: (json['total_volume'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'symbol': symbol,
        'name': name,
        'current_price': currentPrice,
        'price_change_percentage_24h': priceChangePercentage24h,
        'image': image,
        'sparkline_in_7d': {'price': sparklineData},
        'market_cap': marketCap,
        'high_24h': high24h,
        'low_24h': low24h,
        'total_volume': totalVolume,
      };
}
