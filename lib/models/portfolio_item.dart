import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioItem {
  final String id;
  final String coinId;
  final double amount;
  final double purchasePrice;
  final DateTime purchaseDate;

  PortfolioItem({
    required this.id,
    required this.coinId,
    required this.amount,
    required this.purchasePrice,
    required this.purchaseDate,
  });

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      id: json['id'] as String,
      coinId: json['coinId'] as String,
      amount: (json['amount'] as num).toDouble(),
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      purchaseDate: (json['purchaseDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'coinId': coinId,
        'amount': amount,
        'purchasePrice': purchasePrice,
        'purchaseDate': Timestamp.fromDate(purchaseDate),
      };

  double getCurrentValue(double currentPrice) => amount * currentPrice;

  double getProfitLoss(double currentPrice) =>
      getCurrentValue(currentPrice) - (amount * purchasePrice);

  double getProfitLossPercentage(double currentPrice) =>
      ((currentPrice - purchasePrice) / purchasePrice) * 100;
}
