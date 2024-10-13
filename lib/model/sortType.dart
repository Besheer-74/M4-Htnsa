import 'package:shared_preferences/shared_preferences.dart';

import '../fuc/sort_option.dart';

class SortType {
  Future<void> setSortOption(SortOption sortOption) async {
    SharedPreferences option = await SharedPreferences.getInstance();
    await option.setInt('sortoption', sortOption.index);
  }

  Future<SortOption> getSortOption() async {
    SharedPreferences option = await SharedPreferences.getInstance();
    int? sortIndex =
        option.getInt('sortoption') ?? SortOption.ByTimeDescending.index;
    return SortOption.values[sortIndex];
  }
}
