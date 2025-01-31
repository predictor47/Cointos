import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:your_app_name/data/repositories/crypto_repository.dart';
import 'package:your_app_name/data/repositories/user_repository.dart';
import 'package:your_app_name/models/portfolio_item.dart';
import 'package:your_app_name/services/analytics_service.dart';
import 'package:your_app_name/services/crypto_service.dart';
import 'package:your_app_name/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioProvider extends ChangeNotifier {
  final CryptoRepository cryptoRepository;
  final UserRepository userRepository;
  final AnalyticsService analytics;
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, PortfolioItem> _portfolio = {};
  double _totalValue = 0;
  StreamSubscription? _portfolioSubscription;
  StreamSubscription? _priceSubscription;

  PortfolioProvider({
    required this.cryptoRepository,
    required this.userRepository,
    required this.analytics,
  }) {
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
        if (kDebugMode) {
          print('Error streaming portfolio: $error');
        }
      },
    );
  }

  void _updatePriceStream() {
    _priceSubscription?.cancel();
    if (_portfolio.isEmpty) return;

    final coinIds = _portfolio.keys.toList();
    _priceSubscription =
        CryptoService().getPriceStream(coinIds).listen((prices) {
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

  Future<void> addCoin(
      String coinId, double amount, double currentPrice) async {
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

  Future<void> fetchPortfolio() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('portfolio')
          .get();

      if (snapshot.docs.isEmpty) {
        // Handle case where no portfolio items exist
        _portfolio = {};
        notifyListeners();
        return;
      }

      _portfolio = {
        for (var doc in snapshot.docs)
          doc.id: PortfolioItem.fromJson(doc.data())
      };

      _updatePriceStream();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching portfolio: $e');
      }
    }
  }
}
