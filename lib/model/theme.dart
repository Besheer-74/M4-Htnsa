import 'package:shared_preferences/shared_preferences.dart';

class TheTheme {
  Future<void> setTheme(bool theme) async {
    SharedPreferences myTheme = await SharedPreferences.getInstance();
    await myTheme.setBool('theTheme', theme);
  }

  Future<bool> getTheme() async {
    SharedPreferences myTheme = await SharedPreferences.getInstance();
    bool? theme = myTheme.getBool('theTheme') ?? true;
    return theme;
  }
}
