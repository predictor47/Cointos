import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:kointos/core/constants/app_constants.dart';
import 'package:kointos/core/utils/error_handler.dart';
import 'package:kointos/services/analytics_service.dart';
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

  Stream<User?> get authStateChanges =>
      firebaseAuth.authStateChanges().asyncMap((auth.User? firebaseUser) async {
        if (firebaseUser == null) return null;
        try {
          final userDoc = await firestore
              .collection(FirestoreCollections.users)
              .doc(firebaseUser.uid)
              .get();

          if (!userDoc.exists) {
            // Create user document if it doesn't exist
            final newUser = User(
              id: firebaseUser.uid,
              email: firebaseUser.email!,
              username:
                  firebaseUser.displayName ?? firebaseUser.email!.split('@')[0],
            );
            await firestore
                .collection(FirestoreCollections.users)
                .doc(newUser.id)
                .set(newUser.toJson());
            return newUser;
          }

          final data = userDoc.data()!;
          data['id'] = firebaseUser.uid;
          return User.fromJson(data);
        } catch (e) {
          print('Error in authStateChanges: ${e.toString()}');
          return null;
        }
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

      if (!userData.exists) {
        // Create a new user document if it doesn't exist
        final newUser = User(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          username: userCredential.user!.displayName ?? email.split('@')[0],
        );
        await firestore
            .collection(FirestoreCollections.users)
            .doc(newUser.id)
            .set(newUser.toJson());
        return newUser;
      }

      final data = userData.data()!;
      data['id'] = userCredential.user!.uid;
      return User.fromJson(data);
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
          return AppError(
              'No user found with this email', ErrorType.authentication);
        case 'wrong-password':
          return AppError('Invalid password', ErrorType.authentication);
        case 'email-already-in-use':
          return AppError(
              'Email is already registered', ErrorType.authentication);
        case 'invalid-email':
          return AppError('Invalid email address', ErrorType.authentication);
        case 'weak-password':
          return AppError('Password is too weak', ErrorType.authentication);
        case 'user-disabled':
          return AppError(
              'This account has been disabled', ErrorType.authentication);
        case 'invalid-credential':
          return AppError(
              'Invalid email or password', ErrorType.authentication);
        default:
          return AppError(error.message ?? 'Authentication failed',
              ErrorType.authentication);
      }
    }
    if (error is AppError) {
      return error;
    }
    if (error is Exception) {
      return AppError(error.toString(), ErrorType.unknown);
    }
    return AppError('An unknown error occurred', ErrorType.unknown);
  }
}
