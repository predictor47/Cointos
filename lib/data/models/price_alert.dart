import 'package:cloud_firestore/cloud_firestore.dart';

class PriceAlert {
  final String id;
  final String coinId;
  final double targetPrice;
  final bool isAbove;
  final DateTime createdAt;

  PriceAlert({
    required this.id,
    required this.coinId,
    required this.targetPrice,
    required this.isAbove,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PriceAlert.fromJson(Map<String, dynamic> json) {
    return PriceAlert(
      id: json['id'] as String,
      coinId: json['coinId'] as String,
      targetPrice: json['targetPrice'] as double,
      isAbove: json['isAbove'] as bool,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coinId': coinId,
      'targetPrice': targetPrice,
      'isAbove': isAbove,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
} 