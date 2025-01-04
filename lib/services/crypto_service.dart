import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto_model.dart';
import 'package:dio/dio.dart';

class CryptoService {
  final dio = Dio();
  final String baseUrl = 'https://api.coingecko.com/api/v3';

  Future<List<Crypto>> searchCoins(String query) async {
    try {
      final response = await dio.get(
        '$baseUrl/search',
        queryParameters: {'query': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> coins = response.data['coins'];
        return coins
            .take(10) // Limit to first 10 results
            .map((coin) => Crypto.fromJson(coin))
            .toList();
      }
      throw Exception('Failed to search coins');
    } catch (e) {
      throw Exception('Error searching coins: $e');
    }
  }

  Future<List<double>> getPortfolioHistory(
    Map<String, PortfolioItem> portfolio,
    int days,
  ) async {
    try {
      final List<double> totalValues = List.filled(days, 0);
      
      for (var item in portfolio.values) {
        final response = await dio.get(
          '$baseUrl/coins/${item.coinId}/market_chart',
          queryParameters: {
            'vs_currency': 'usd',
            'days': days,
            'interval': 'daily',
          },
        );

        if (response.statusCode == 200) {
          final List<List<dynamic>> prices = List<List<dynamic>>.from(
            response.data['prices'],
          );

          for (int i = 0; i < days && i < prices.length; i++) {
            totalValues[i] += (prices[i][1] as num).toDouble() * item.amount;
          }
        }
      }

      return totalValues;
    } catch (e) {
      throw Exception('Error fetching portfolio history: $e');
    }
  }

  Stream<Map<String, double>> getPriceStream(List<String> coinIds) async* {
    while (true) {
      try {
        final response = await dio.get(
          '$baseUrl/simple/price',
          queryParameters: {
            'ids': coinIds.join(','),
            'vs_currencies': 'usd',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, double> prices = {};
          final data = response.data as Map<String, dynamic>;
          
          for (var coinId in coinIds) {
            if (data.containsKey(coinId)) {
              prices[coinId] = data[coinId]['usd'].toDouble();
            }
          }
          
          yield prices;
        }
      } catch (e) {
        print('Error fetching prices: $e');
      }
      
      await Future.delayed(const Duration(seconds: 30));
    }
  }
}
