import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto_model.dart';

class CryptoService {
  final String _baseUrl = 'https://api.coingecko.com/api/v3';

  Future<List<Crypto>> fetchCryptos() async {
    final url = '$_baseUrl/coins/markets?vs_currency=usd';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Crypto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cryptos');
    }
  }

  Future<List<double>> fetchHistoricalData(String id, int days) async {
    final url = '$_baseUrl/coins/$id/market_chart?vs_currency=usd&days=$days';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> priceData = data['prices'];

      List<double> prices = priceData.map((price) {
        return (price[1] as num).toDouble(); // Convert to double
      }).toList();

      return prices;
    } else {
      throw Exception('Failed to load historical data');
    }
  }
}
