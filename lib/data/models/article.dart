import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kointos/core/config/app_config.dart';

class Article {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String source;
  final DateTime publishDate;
  final List<String> tags;
  final int readTimeMinutes;
  final int rewardPoints;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.source,
    required this.publishDate,
    required this.tags,
    required this.readTimeMinutes,
    this.rewardPoints = AppConfig.articleReadPoints,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String,
      source: json['source'] as String,
      publishDate: (json['publishDate'] as Timestamp).toDate(),
      tags: List<String>.from(json['tags'] as List),
      readTimeMinutes: json['readTimeMinutes'] as int,
      rewardPoints: json['rewardPoints'] as int? ?? AppConfig.articleReadPoints,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'source': source,
      'publishDate': Timestamp.fromDate(publishDate),
      'tags': tags,
      'readTimeMinutes': readTimeMinutes,
      'rewardPoints': rewardPoints,
    };
  }
}
