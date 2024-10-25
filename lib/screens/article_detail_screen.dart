import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/article.dart';
import '../services/user_service.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool _isLoading = true;
  bool _pointsAwarded = false;
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article.source),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadRequest(Uri.parse(widget.article.url))
              ..setNavigationDelegate(
                NavigationDelegate(
                  onPageFinished: (_) {
                    setState(() {
                      _isLoading = false;
                    });
                    _awardPoints();
                  },
                ),
              ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  void _awardPoints() async {
    if (!_pointsAwarded) {
      await _userService.awardPoints(10); // Award 10 points for reading
      setState(() {
        _pointsAwarded = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You earned 10 points for reading!')),
      );
    }
  }
}
