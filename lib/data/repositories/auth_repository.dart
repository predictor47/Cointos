class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges().map((firebaseUser) {
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
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = User(
        id: userCredential.user!.uid,
        email: email,
        username: username,
      );

      await _firestore
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
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userData = await _firestore
          .collection(FirestoreCollections.users)
          .doc(userCredential.user!.uid)
          .get();

      return User.fromJson(userData.data()!);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  AppError _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
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