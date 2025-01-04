class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SharedPreferences _prefs;

  UserRepository(this._prefs);

  Future<User> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .get();

      if (!doc.exists) {
        throw AppError('User not found', ErrorType.authentication);
      }

      return User.fromJson(doc.data()!);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(user.id)
          .update(user.toJson());
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updatePoints(String userId, int points) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .update({
        'totalPoints': FieldValue.increment(points),
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> canSpin(String userId) async {
    try {
      final user = await getUser(userId);
      final now = DateTime.now();
      
      if (user.lastSpinTime.day != now.day) {
        await _firestore
            .collection(FirestoreCollections.users)
            .doc(userId)
            .update({
          'dailySpins': 0,
        });
        return true;
      }

      return user.dailySpins < AppConfig.dailySpinLimit;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> recordSpin(String userId) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .update({
        'dailySpins': FieldValue.increment(1),
        'lastSpinTime': Timestamp.now(),
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  AppError _handleError(dynamic error) {
    if (error is FirebaseException) {
      return AppError(error.message ?? ErrorMessages.serverError, ErrorType.server);
    }
    if (error is AppError) {
      return error;
    }
    return AppError(ErrorMessages.unknownError, ErrorType.unknown);
  }
} 