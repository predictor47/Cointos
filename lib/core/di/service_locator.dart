final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External Dependencies
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  final dio = Dio()
    ..options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    )
    ..interceptors.add(LogInterceptor(
      request: true,
      responseBody: true,
      error: true,
      requestBody: true,
      requestHeader: true,
      responseHeader: true,
    ));
  getIt.registerSingleton<Dio>(dio);

  // Firebase Services
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);

  // Services
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(getIt()),
  );
  getIt.registerLazySingleton<AnalyticsService>(
    () => AnalyticsService(),
  );
  getIt.registerLazySingleton<CacheService>(
    () => CacheService(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      auth: getIt(),
      firestore: getIt(),
      analytics: getIt(),
    ),
  );
  
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(
      firestore: getIt(),
      storage: getIt(),
      analytics: getIt(),
    ),
  );
  
  getIt.registerLazySingleton<CryptoRepository>(
    () => CryptoRepository(
      getIt<Dio>(),
      getIt<SharedPreferences>(),
      getIt<FirebaseFirestore>(),
    ),
  );

  // Providers
  getIt.registerFactory<SettingsProvider>(
    () => SettingsProvider(getIt()),
  );
  
  getIt.registerFactory<PortfolioProvider>(
    () => PortfolioProvider(
      cryptoRepository: getIt(),
      userRepository: getIt(),
      analytics: getIt(),
    ),
  );
  
  getIt.registerFactory<RewardsProvider>(
    () => RewardsProvider(
      userRepository: getIt(),
      analytics: getIt(),
    ),
  );
}

// Optional: Cache Service implementation for better data management
class CacheService {
  final SharedPreferences _prefs;

  CacheService(this._prefs);

  Future<void> saveData(String key, dynamic data) async {
    if (data is int) {
      await _prefs.setInt(key, data);
    } else if (data is double) {
      await _prefs.setDouble(key, data);
    } else if (data is bool) {
      await _prefs.setBool(key, data);
    } else if (data is String) {
      await _prefs.setString(key, data);
    } else if (data is List<String>) {
      await _prefs.setStringList(key, data);
    } else {
      await _prefs.setString(key, jsonEncode(data));
    }
  }

  T? getData<T>(String key) {
    try {
      if (T == int) {
        return _prefs.getInt(key) as T?;
      } else if (T == double) {
        return _prefs.getDouble(key) as T?;
      } else if (T == bool) {
        return _prefs.getBool(key) as T?;
      } else if (T == String) {
        return _prefs.getString(key) as T?;
      } else if (T == List<String>) {
        return _prefs.getStringList(key) as T?;
      } else {
        final data = _prefs.getString(key);
        if (data != null) {
          return jsonDecode(data) as T?;
        }
      }
    } catch (e) {
      debugPrint('Error retrieving cached data: $e');
    }
    return null;
  }

  Future<void> removeData(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clearCache() async {
    await _prefs.clear();
  }
} 