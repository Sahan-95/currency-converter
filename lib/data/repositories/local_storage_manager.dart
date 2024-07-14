import 'package:shared_preferences/shared_preferences.dart';

class LocalDataStorageManager {
  static SharedPreferences? _preferences;

  static const _userFavorite = "Favorite";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUserFavorite(String userFavorite) async =>
      await _preferences?.setString(_userFavorite, userFavorite);

  static String? getUserFavorite() => _preferences?.getString(_userFavorite);

  static Future deleteUserFavorite() async {
    await _preferences?.remove(_userFavorite);
  }
}
