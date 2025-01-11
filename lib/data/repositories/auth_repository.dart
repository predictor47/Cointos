import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:your_app_name/core/constants/app_constants.dart';
import 'package:your_app_name/core/utils/error_handler.dart';
import 'package:your_app_name/services/analytics_service.dart';
import '../models/user.dart';

class AuthRepository {
  final auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final AnalyticsService analytics;

  AuthRepository({
    required this.firebaseAuth,
    required this.firestore,
    required this.analytics,
  });

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges().map((auth.User? firebaseUser) {
        return firebaseUser == null ? null : User(
          id: firebaseUser.uid,
          email: firebaseUser.email!,
          username: firebaseUser.displayName ?? '',
        );
      });

  Future<User> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = User(
        id: userCredential.user!.uid,
        email: email,
        username: username,
      );

      await firestore
          .collection(FirestoreCollections.users)
          .doc(user.id)
          .set(user.toJson());

      await userCredential.user!.updateDisplayName(username);

      return user;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userData = await firestore
          .collection(FirestoreCollections.users)
          .doc(userCredential.user!.uid)
          .get();

      return User.fromJson(userData.data()!);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  AppError _handleAuthError(dynamic error) {
    if (error is auth.FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return AppError('No user found with this email', ErrorType.authentication);
        case 'wrong-password':
          return AppError('Invalid password', ErrorType.authentication);
        case 'email-already-in-use':
          return AppError('Email is already registered', ErrorType.authentication);
        default:
          return AppError(error.message ?? ErrorMessages.authError, ErrorType.authentication);
      }
    }
    return AppError(ErrorMessages.unknownError, ErrorType.unknown);
  }
} 