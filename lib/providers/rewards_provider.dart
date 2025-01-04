class RewardsProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  int _totalPoints = 0;
  StreamSubscription? _pointsSubscription;

  RewardsProvider() {
    _initializePoints();
  }

  void _initializePoints() {
    _pointsSubscription = _firebaseService.streamTotalPoints().listen(
      (points) {
        _totalPoints = points;
        notifyListeners();
      },
      onError: (error) {
        print('Error streaming points: $error');
      },
    );
  }

  @override
  void dispose() {
    _pointsSubscription?.cancel();
    super.dispose();
  }

  int get totalPoints => _totalPoints;

  Future<void> addPoints(int points, String source) async {
    await _firebaseService.addRewardPoints(points, source);
  }

  Future<List<Map<String, dynamic>>> getRewardHistory() async {
    return _firebaseService.getRewardHistory();
  }

  Future<void> markArticleAsRead(String articleId) async {
    await _firebaseService.markArticleAsRead(articleId);
  }

  Future<bool> hasReadArticle(String articleId) async {
    return _firebaseService.hasReadArticle(articleId);
  }
} 