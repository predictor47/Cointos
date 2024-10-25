// lib/services/news_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  static const String baseUrl = 'https://newsapi.org/v2';
  // You can also use cryptocompare API as an alternative
  // static const String baseUrl = 'https://min-api.cryptocompare.com/data/v2';

  // Replace with your API key from newsapi.org
  static const String apiKey = 'a9b366c9973e420eb982a19fe82d3a16';

  Future<List<Article>> fetchNews(int page) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/everything?q=cryptocurrency+crypto+bitcoin&language=en&sortBy=publishedAt&pageSize=10&page=$page&apiKey=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['articles'] as List)
            .map((article) => Article.fromJson(article))
            .toList();
        return articles;
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

  // Alternative method using CryptoCompare API
  Future<List<Article>> fetchCryptoCompareNews() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://min-api.cryptocompare.com/data/v2/news/?lang=EN&api_key=YOUR_CRYPTOCOMPARE_API_KEY'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['Data'] as List).map((article) {
          return Article(
            title: article['title'],
            source: article['source'],
            url: article['url'],
            description: article['body'],
            imageUrl: article['imageurl'],
            publishedAt: DateTime.fromMillisecondsSinceEpoch(
              article['published_on'] * 1000,
            ).toIso8601String(),
            content: article['body'],
          );
        }).toList();
        return articles;
      } else {
        throw Exception('Failed to load news from CryptoCompare');
      }
    } catch (e) {
      throw Exception('Error fetching CryptoCompare news: $e');
    }
  }
}
