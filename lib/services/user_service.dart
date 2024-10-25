import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class UserService {
  static const String _userPointsKey = 'userPoints';
  static const String _lastSpinKey = 'lastSpin';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();

  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        await _createUserDocument(user.uid, name, email, phone);
      }

      return user;
    } catch (e) {
      _logger.e('Sign up error', error: e);
      return null;
    }
  }

  Future<void> _createUserDocument(
      String userId, String name, String email, String phone) async {
    await _firestore.collection('users').doc(userId).set({
      'name': name,
      'email': email,
      'phone': phone,
      'userId': userId,
      'points': 0,
      'role': 'user',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> awardPoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    final currentPoints = prefs.getInt(_userPointsKey) ?? 0;
    await prefs.setInt(_userPointsKey, currentPoints + points);
  }

  Future<bool> canSpinWheel() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSpin = prefs.getInt(_lastSpinKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    return now - lastSpin >= 24 * 60 * 60 * 1000;
  }

  Future<int> spinWheel() async {
    if (await canSpinWheel()) {
      final prefs = await SharedPreferences.getInstance();
      final points = Random().nextInt(100) + 1; // Random points between 1-100
      await awardPoints(points);
      await prefs.setInt(_lastSpinKey, DateTime.now().millisecondsSinceEpoch);
      return points;
    }
    return 0;
  }

  Future<Map<String, String>> getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return data.map((key, value) => MapEntry(key, value.toString()));
        } else {
          throw Exception('User document not found');
        }
      } catch (e) {
        throw Exception('Failed to load user data: $e');
      }
    } else {
      throw Exception('No authenticated user');
    }
  }

  // Add methods to get user data (name, email, phone, points, etc.)
}
