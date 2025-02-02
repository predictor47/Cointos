import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../core/utils/error_handler.dart';
import '../data/repositories/auth_repository.dart';
import '../data/models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;
  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  AuthProvider(this._authRepository) {
    // Listen to auth state changes
    _authRepository.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authRepository.signIn(
        email: email,
        password: password,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = ErrorHandler.getMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password, String username) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authRepository.signUp(
        email: email,
        password: password,
        username: username,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = ErrorHandler.getMessage(e);
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
      await _authRepository.resetPassword(email);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.signOut();
      _user = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_user == null) throw 'No user logged in';

      // First verify the current password by attempting to sign in
      await _authRepository.signIn(
        email: _user!.email,
        password: currentPassword,
      );

      // Sign back in with new password
      _user = await _authRepository.signIn(
        email: _user!.email,
        password: newPassword,
      );
    } catch (e) {
      _errorMessage = e.toString();
      throw _errorMessage!;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
