class Coin {
  final String id;
  final String symbol;
  final String name;
  final double currentPrice;
  final List<double> sparklineIn7d;

  Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.sparklineIn7d,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      currentPrice: json['current_price'].toDouble(),
      sparklineIn7d: List<double>.from(json['sparkline_in_7d']['price']),
    );
  }
}
