import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kointos/data/repositories/auth_repository.dart';
import 'package:kointos/data/repositories/crypto_repository.dart';
import 'package:kointos/data/repositories/user_repository.dart';
import 'package:kointos/providers/portfolio_provider.dart';
import 'package:kointos/providers/rewards_provider.dart';
import 'package:kointos/providers/settings_provider.dart';
import 'package:kointos/providers/auth_provider.dart' as app_auth;
import 'package:kointos/services/analytics_service.dart';
import 'package:kointos/services/notification_service.dart';
import 'package:kointos/services/crypto_service.dart';
import '../constants/api_constants.dart';

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
    () => NotificationService(),
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
      firebaseAuth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
      analytics: getIt<AnalyticsService>(),
    ),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(
      firestore: getIt<FirebaseFirestore>(),
      storage: getIt<FirebaseStorage>(),
      analytics: getIt<AnalyticsService>(),
    ),
  );

  getIt.registerLazySingleton<CryptoRepository>(
    () => CryptoRepository(
      getIt<Dio>(),
      getIt<SharedPreferences>(),
      getIt<FirebaseFirestore>(),
    ),
  );

  // Services
  getIt.registerLazySingleton<CryptoService>(
    () => CryptoService(repository: getIt<CryptoRepository>()),
  );

  // Providers
  getIt.registerFactory<SettingsProvider>(
    () => SettingsProvider(),
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

  getIt.registerFactory<app_auth.AuthProvider>(
    () => app_auth.AuthProvider(getIt<AuthRepository>()),
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
