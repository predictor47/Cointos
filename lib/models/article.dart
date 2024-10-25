// lib/models/article.dart

class Article {
  final String title;
  final String source;
  final String url;
  final String description;
  final String? imageUrl;
  final String publishedAt;
  final String content;

  Article({
    required this.title,
    required this.source,
    required this.url,
    required this.description,
    this.imageUrl,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      source: json['source']['name'] ?? '',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['urlToImage'],
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'source': {'name': source},
      'url': url,
      'description': description,
      'urlToImage': imageUrl,
      'publishedAt': publishedAt,
      'content': content,
    };
  }
}
