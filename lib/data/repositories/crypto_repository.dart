import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_app_name/core/constants/api_constants.dart';
import 'package:your_app_name/core/utils/error_handler.dart';
import 'package:your_app_name/models/crypto_model.dart';
import '../models/price_alert.dart';
import '../../core/exceptions/auth_exceptions.dart';
import '../models/chart_data.dart';

class CryptoRepository {
  final Dio _dio;
  final SharedPreferences _prefs;
  final FirebaseFirestore _firestore;

  CryptoRepository(this._dio, this._prefs, this._firestore);

  Future<List<Crypto>> getTopCoins({int limit = 100}) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/coins/markets',
        queryParameters: {
          'vs_currency': _prefs.getString('currency') ?? 'usd',
          'order': 'market_cap_desc',
          'per_page': limit,
          'page': 1,
          'sparkline': true,
        },
      );

      return (response.data as List)
          .map((json) => Crypto.fromJson(json))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Crypto> getCoinDetails(String id) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/coins/$id',
        queryParameters: {
          'localization': false,
          'tickers': false,
          'market_data': true,
          'community_data': false,
          'developer_data': false,
          'sparkline': true,
        },
      );

      return Crypto.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<PriceAlert>> getPriceAlerts() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('price_alerts')
          .get();

      return snapshot.docs
          .map((doc) => PriceAlert.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> setPriceAlert(PriceAlert alert) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw UnauthorizedException();

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('price_alerts')
          .doc(alert.id)
          .set(alert.toJson());
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> deletePriceAlert(String alertId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw UnauthorizedException();

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('price_alerts')
          .doc(alertId)
          .delete();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<ChartData>> getCoinChart(String id, String days) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/coins/$id/market_chart',
        queryParameters: {
          'vs_currency': _prefs.getString('currency') ?? 'usd',
          'days': days,
        },
      );

      final prices = response.data['prices'] as List;
      return prices
          .map((price) => ChartData(
                timestamp: DateTime.fromMillisecondsSinceEpoch(price[0] as int),
                value: price[1] as double,
              ))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> cacheCoinData(List<Crypto> coins) async {
    try {
      await _prefs.setString(
        'cached_coins',
        jsonEncode(coins.map((coin) => coin.toJson()).toList()),
      );
      await _prefs.setInt(
          'cache_timestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Handle cache error silently
      debugPrint('Error caching coin data: $e');
    }
  }

  List<Crypto>? getCachedCoins() {
    try {
      final cachedData = _prefs.getString('cached_coins');
      final cacheTimestamp = _prefs.getInt('cache_timestamp');

      if (cachedData == null || cacheTimestamp == null) return null;

      // Check if cache is older than 5 minutes
      if (DateTime.now().millisecondsSinceEpoch - cacheTimestamp > 300000) {
        return null;
      }

      final List<dynamic> decoded = jsonDecode(cachedData);
      return decoded.map((json) => Crypto.fromJson(json)).toList();
    } catch (e) {
      return null;
    }
  }

  Stream<Map<String, double>> getPriceStream(List<String> coinIds) {
    return Stream.periodic(const Duration(seconds: 10)).asyncMap((_) async {
      final coins = await getTopCoins(limit: 100);
      return {
        for (var coin in coins.where((c) => coinIds.contains(c.id)))
          coin.id: coin.currentPrice
      };
    });
  }
}
