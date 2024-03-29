import 'db.dart';

class ReadData {
  String? username;
  String? email;
  String? avatar;
  int? id;
  int? theme;
  SqlDb sqlDb = SqlDb();
  bool? isDark;

  Future<void> readUser() async {
    List<Map> data = await sqlDb.read("users");
    for (Map<dynamic, dynamic> item in data) {
      id = item['id'];
      username = item['username'];
      email = item['email'];
      avatar = item['avatar'];
      theme = item['theme'];

      theme == 1 ? isDark = true : isDark = false;
    }
  }
}
