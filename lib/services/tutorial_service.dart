class TutorialService {
  static const String _tutorialShownKey = 'tutorial_shown';

  static Future<bool> shouldShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return !prefs.getBool(_tutorialShownKey) ?? true;
  }

  static Future<void> markTutorialAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialShownKey, true);
  }
} 