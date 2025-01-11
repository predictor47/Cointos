import 'package:shared_preferences/shared_preferences.dart';

class TutorialService {
  static const String _tutorialShownKey = 'tutorial_shown';
  static final _prefs = SharedPreferences.getInstance();

  static Future<bool> hasShownTutorial() async {
    final prefs = await _prefs;
    return prefs.getBool(_tutorialShownKey) ?? false;
  }

  static Future<void> markTutorialAsShown() async {
    final prefs = await _prefs;
    await prefs.setBool(_tutorialShownKey, true);
  }

  static Future<void> resetTutorial() async {
    final prefs = await _prefs;
    await prefs.setBool(_tutorialShownKey, false);
  }
}
