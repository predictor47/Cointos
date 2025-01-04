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

  double getCurrentValue(double currentPrice) {
    return amount * currentPrice;
  }

  double getProfitLoss(double currentPrice) {
    return getCurrentValue(currentPrice) - (amount * purchasePrice);
  }

  double getProfitLossPercentage(double currentPrice) {
    return ((currentPrice - purchasePrice) / purchasePrice) * 100;
  }
} 