import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth 
 _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null; 
    notifyListeners();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user
 = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code 
 == 'user-not-found') {
        _errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        _errorMessage = 'Wrong password provided for that user.'; 

      } else {
        _errorMessage 
 = 'An error occurred during login.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password) async {
    _isLoading = true;
    _errorMessage = null; 
    notifyListeners();

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password); 

      _user = userCredential.user; 

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        _errorMessage 
 = 'The account already exists for that email.';
      } else {
        _errorMessage = 'An error occurred during signup.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = null; 
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _errorMessage = 'No user found for that email.';
      } else {
        _errorMessage = 'An error occurred while sending the password reset email.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners(); 
  }
}
