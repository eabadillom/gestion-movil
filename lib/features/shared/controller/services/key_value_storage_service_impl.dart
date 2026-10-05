import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorageServiceImpl 
{
  static Future<SharedPreferences> getSharedPrefs() async 
  {
    return await SharedPreferences.getInstance();
  }

  static Future<T?> getValue<T>(String key) async
  {
    final prefs = await getSharedPrefs();

    if (T == int) {
      return prefs.getInt(key) as T?;
    }

    if (T == double) {
      return prefs.getDouble(key) as T?;
    }

    if (T == bool) {
      return prefs.getBool(key) as T?;
    }

    if (T == String) {
      return prefs.getString(key) as T?;
    }

    if (T == List<String>) {
      return prefs.getStringList(key) as T?;
    }

    throw UnimplementedError('GET not implemented for type $T');
  }

  static Future<bool> removeKey(String key) async 
  {
    final prefs = await getSharedPrefs();
    return await prefs.remove(key);
  }

  static Future<void> setKeyValue<T>(String key, T value) async
   {
    final prefs = await getSharedPrefs();

    if (T == int) {
      await prefs.setInt(key, value as int);
      return;
    }

    if (T == double) {
      await prefs.setDouble(key, value as double);
      return;
    }

    if (T == bool) {
      await prefs.setBool(key, value as bool);
      return;
    }

    if (T == String) {
      await prefs.setString(key, value as String);
      return;
    }

    if (T == List<String>) {
      await prefs.setStringList(key, value as List<String>);
      return;
    }

    throw UnimplementedError('SET not implemented for type $T'); 
  }

}
