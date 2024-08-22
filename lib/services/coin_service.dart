import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coin_model.dart';

class CoinService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';

  Future<List<Coin>> getTopCoins({int limit = 10}) async {
    try {
      final response = await http.get(Uri.parse(
          '$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$limit&page=1&sparkline=true'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Coin.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load top coins');
      }
    } catch (e) {
      throw Exception('Error fetching top coins: $e');
    }
  }

  Future<List<Coin>> getAllCoins({int limit = 100}) async {
    try {
      final response = await http.get(Uri.parse(
          '$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$limit&page=1&sparkline=true'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Coin.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load all coins');
      }
    } catch (e) {
      throw Exception('Error fetching all coins: $e');
    }
  }
}