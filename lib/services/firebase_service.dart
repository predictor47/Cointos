import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/portfolio_item.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Portfolio Collection Reference
  CollectionReference<Map<String, dynamic>> get _portfolioCollection =>
      _firestore.collection('users').doc(currentUserId).collection('portfolio');

  // Rewards Collection Reference
  CollectionReference<Map<String, dynamic>> get _rewardsCollection =>
      _firestore.collection('users').doc(currentUserId).collection('rewards');

  // Portfolio Methods
  Future<void> savePortfolioItem(PortfolioItem item) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    await _portfolioCollection.doc(item.coinId).set({
      'amount': item.amount,
      'purchasePrice': item.purchasePrice,
      'purchaseDate': item.purchaseDate.toIso8601String(),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updatePortfolioItem(String coinId, double newAmount) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    await _portfolioCollection.doc(coinId).update({
      'amount': newAmount,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removePortfolioItem(String coinId) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    await _portfolioCollection.doc(coinId).delete();
  }

  Stream<Map<String, PortfolioItem>> streamPortfolio() {
    if (currentUserId == null) throw Exception('User not authenticated');

    return _portfolioCollection.snapshots().map((snapshot) {
      final Map<String, PortfolioItem> portfolio = {};
      for (var doc in snapshot.docs) {
        portfolio[doc.id] = PortfolioItem(
          id: doc.id,
          coinId: doc.id,
          amount: doc.data()['amount'],
          purchasePrice: doc.data()['purchasePrice'],
          purchaseDate: DateTime.parse(doc.data()['purchaseDate']),
        );
      }
      return portfolio;
    });
  }

  // Rewards Methods
  Future<void> addRewardPoints(int points, String source) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    await _rewardsCollection.add({
      'points': points,
      'source': source,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update total points
    final userRef = _firestore.collection('users').doc(currentUserId);
    await userRef.set({
      'totalPoints': FieldValue.increment(points),
    }, SetOptions(merge: true));
  }

  Stream<int> streamTotalPoints() {
    if (currentUserId == null) throw Exception('User not authenticated');

    return _firestore
        .collection('users')
        .doc(currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.data()?['totalPoints'] ?? 0);
  }

  Future<List<Map<String, dynamic>>> getRewardHistory() async {
    if (currentUserId == null) throw Exception('User not authenticated');

    final querySnapshot = await _rewardsCollection
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();

    return querySnapshot.docs
        .map((doc) => {
              'points': doc.data()['points'],
              'source': doc.data()['source'],
              'timestamp': (doc.data()['timestamp'] as Timestamp).toDate(),
            })
        .toList();
  }

  // Article Reading Tracking
  Future<void> markArticleAsRead(String articleId) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    final articleRef = _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('readArticles')
        .doc(articleId);

    final doc = await articleRef.get();
    if (!doc.exists) {
      await articleRef.set({
        'readAt': FieldValue.serverTimestamp(),
      });
      // Award points for first-time reading
      await addRewardPoints(5, 'Article Read: $articleId');
    }
  }

  Future<bool> hasReadArticle(String articleId) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    final doc = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('readArticles')
        .doc(articleId)
        .get();

    return doc.exists;
  }

  DocumentReference getUserDocument() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('No authenticated user');
    return _firestore.collection('users').doc(userId);
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('No authenticated user');
    await _firestore.collection('users').doc(userId).update(data);
  }
}
