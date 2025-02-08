import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:kointos/data/repositories/article_repository.dart';
import 'package:kointos/data/repositories/crypto_repository.dart';
import 'package:kointos/data/repositories/auth_repository.dart';
import 'package:kointos/data/repositories/user_repository.dart';
import 'package:kointos/services/analytics_service.dart';
import 'package:kointos/services/article_service.dart';
import 'package:kointos/services/image_service.dart';
import 'package:kointos/services/user_profile_service.dart';
import 'package:kointos/services/user_service.dart';
import 'package:kointos/providers/auth_provider.dart' as app;
import 'package:kointos/providers/user_provider.dart';
import 'package:kointos/providers/portfolio_provider.dart';
import 'package:kointos/providers/rewards_provider.dart';
import 'package:kointos/providers/settings_provider.dart';
import 'package:kointos/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerSingleton<Dio>(Dio());

  // Firebase
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
  sl.registerSingleton<FirebaseAnalytics>(FirebaseAnalytics.instance);

  // Analytics should be registered first since other services depend on it
  sl.registerSingleton<AnalyticsService>(
    AnalyticsService(analytics: sl<FirebaseAnalytics>()),
  );

  // Services
  sl.registerSingleton<ImageService>(
    ImageService(firebaseStorage: sl()),
  );

  // Repositories
  sl.registerSingleton<AuthRepository>(
    AuthRepository(
      firebaseAuth: sl(),
      firestore: sl(),
      analytics: sl(),
    ),
  );

  sl.registerSingleton<UserRepository>(
    UserRepository(
      firestore: sl(),
      imageService: sl(),
    ),
  );

  sl.registerSingleton<ArticleRepository>(
    ArticleRepository(
      firestore: sl(),
    ),
  );

  sl.registerSingleton<CryptoRepository>(
    CryptoRepository(
      sl<Dio>(),
      sl<SharedPreferences>(),
      sl<FirebaseFirestore>(),
    ),
  );

  // Register Firebase Service
  sl.registerSingleton<FirebaseService>(
    FirebaseService(
      auth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
      storage: sl<FirebaseStorage>(),
    ),
  );

  // Business Logic Services
  sl.registerSingleton<UserService>(
    UserService(
      userRepository: sl(),
      analytics: sl(),
    ),
  );

  sl.registerSingleton<UserProfileService>(
    UserProfileService(
      userRepository: sl(),
      imageService: sl(),
    ),
  );

  sl.registerSingleton<ArticleService>(
    ArticleService(
      repository: sl(),
      userRepository: sl(),
      firebaseAuth: sl(),
    ),
  );

  // Register providers
  sl.registerFactory<app.AuthProvider>(
    () => app.AuthProvider(
      repository: sl<AuthRepository>(),
      analytics: sl<AnalyticsService>(),
    ),
  );

  sl.registerFactory<UserProvider>(
    () => UserProvider(
      userService: sl<UserService>(),
      userProfileService: sl<UserProfileService>(),
    ),
  );

  sl.registerFactory<PortfolioProvider>(
    () => PortfolioProvider(
      cryptoRepository: sl<CryptoRepository>(),
      userRepository: sl<UserRepository>(),
      analytics: sl<AnalyticsService>(),
    ),
  );

  sl.registerFactory<RewardsProvider>(
    () => RewardsProvider(
      userRepository: sl<UserRepository>(),
      analytics: sl<AnalyticsService>(),
      firebaseService: sl<FirebaseService>(),
    ),
  );

  sl.registerFactory<SettingsProvider>(
    () => SettingsProvider(
      prefs: sl<SharedPreferences>(),
    ),
  );
}
