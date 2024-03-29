import 'package:shared_preferences/shared_preferences.dart';

class TheTheme {
  bool isDark = true;

  Future<void> setTheme(bool theme) async {
    SharedPreferences myTheme = await SharedPreferences.getInstance();
    await myTheme.setBool('theTheme', theme);
    isDark = theme; // Update the local variable
  }

  Future<bool> getTheme() async {
    SharedPreferences myTheme = await SharedPreferences.getInstance();
    bool? theme = myTheme.getBool('theTheme');
    if (theme != null) {
      isDark = theme; // Update the local variable
      return theme;
    } else {
      return isDark; // Return the default value if theme is null
    }
  }
}
