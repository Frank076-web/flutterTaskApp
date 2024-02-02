import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecuredAndSharedPreferencesService {
  static late SharedPreferences _prefs;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  SecuredAndSharedPreferencesService._private();

  static final SecuredAndSharedPreferencesService _instance =
      SecuredAndSharedPreferencesService._private();

  static SecuredAndSharedPreferencesService getInstance() {
    return _instance;
  }

  Future<String?> getSecured(String key) => _secureStorage.read(key: key);
  Future<void> writeSecured(String key, String value) =>
      _secureStorage.write(key: key, value: value);
  Future<void> deleteSecured(String key) => _secureStorage.delete(key: key);

  String? getShared(String key) => _prefs.getString(key);
  void writeShared(String key, String value) => _prefs.setString(key, value);
  void deleteShared(String key) => _prefs.remove(key);

  static Future<void> configurePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
