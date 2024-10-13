import 'package:shared_preferences/shared_preferences.dart';

class Thetypeoflist {
  Future<void> settype(bool list) async {
    SharedPreferences myTypeoflist = await SharedPreferences.getInstance();
    await myTypeoflist.setBool('the type', list);
  }

  Future<bool> getType() async {
    SharedPreferences myTypeoflist = await SharedPreferences.getInstance();
    bool? list = myTypeoflist.getBool('the type') ?? true;
    return list;
  }
}
