import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  String _currency = 'USD';
  bool _priceAlerts = true;
  bool _newsUpdates = true;
  bool _biometricEnabled = false;

  bool get isDarkMode => _isDarkMode;
  String get currency => _currency;
  bool get priceAlerts => _priceAlerts;
  bool get newsUpdates => _newsUpdates;
  bool get biometricEnabled => _biometricEnabled;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setCurrency(String value) {
    _currency = value;
    notifyListeners();
  }

  void setPriceAlerts(bool value) {
    _priceAlerts = value;
    notifyListeners();
  }

  void setNewsUpdates(bool value) {
    _newsUpdates = value;
    notifyListeners();
  }

  void setBiometricEnabled(bool value) {
    _biometricEnabled = value;
    notifyListeners();
  }
}
