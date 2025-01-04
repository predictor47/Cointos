class PortfolioProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  Map<String, PortfolioItem> _portfolio = {};
  double _totalValue = 0;
  StreamSubscription? _portfolioSubscription;
  StreamSubscription? _priceSubscription;

  PortfolioProvider() {
    _initializePortfolio();
  }

  void _initializePortfolio() {
    _portfolioSubscription = _firebaseService.streamPortfolio().listen(
      (portfolio) {
        _portfolio = portfolio;
        _updatePriceStream();
        notifyListeners();
      },
      onError: (error) {
        print('Error streaming portfolio: $error');
      },
    );
  }

  void _updatePriceStream() {
    _priceSubscription?.cancel();
    if (_portfolio.isEmpty) return;

    final coinIds = _portfolio.keys.toList();
    _priceSubscription = CryptoService()
        .getPriceStream(coinIds)
        .listen((prices) {
          _updatePortfolioValue(prices);
        });
  }

  void _updatePortfolioValue(Map<String, double> prices) {
    double total = 0;
    for (var item in _portfolio.values) {
      final price = prices[item.coinId] ?? 0;
      total += item.getCurrentValue(price);
    }
    _totalValue = total;
    notifyListeners();
  }

  @override
  void dispose() {
    _portfolioSubscription?.cancel();
    _priceSubscription?.cancel();
    super.dispose();
  }

  Map<String, PortfolioItem> get portfolio => _portfolio;
  double get totalValue => _totalValue;

  Future<void> addCoin(String coinId, double amount, double currentPrice) async {
    if (_portfolio.containsKey(coinId)) {
      throw Exception('Coin already exists in portfolio');
    }

    final item = PortfolioItem(
      id: coinId,
      coinId: coinId,
      amount: amount,
      purchasePrice: currentPrice,
      purchaseDate: DateTime.now(),
    );

    await _firebaseService.savePortfolioItem(item);
  }

  Future<void> updateCoinAmount(String coinId, double newAmount) async {
    await _firebaseService.updatePortfolioItem(coinId, newAmount);
  }

  Future<void> removeCoin(String coinId) async {
    await _firebaseService.removePortfolioItem(coinId);
  }
} 