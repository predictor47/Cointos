class SettingsProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  
  SettingsProvider(this._prefs);

  bool get isDarkMode => _prefs.getBool('darkMode') ?? true;
  String get currency => _prefs.getString('currency') ?? 'USD';
  bool get priceAlerts => _prefs.getBool('priceAlerts') ?? true;
  bool get newsUpdates => _prefs.getBool('newsUpdates') ?? true;
  bool get biometricEnabled => _prefs.getBool('biometricEnabled') ?? false;

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool('darkMode', value);
    notifyListeners();
  }

  Future<void> setCurrency(String value) async {
    await _prefs.setString('currency', value);
    notifyListeners();
  }

  Future<void> setPriceAlerts(bool value) async {
    await _prefs.setBool('priceAlerts', value);
    notifyListeners();
  }

  Future<void> setNewsUpdates(bool value) async {
    await _prefs.setBool('newsUpdates', value);
    notifyListeners();
  }

  Future<void> setBiometricEnabled(bool value) async {
    await _prefs.setBool('biometricEnabled', value);
    notifyListeners();
  }
} 