import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {
  final _storage = const FlutterSecureStorage();
  
  static const String keyGithubUser = 'gh_user';
  static const String keyGithubToken = 'gh_token';
  static const String keyLeetcodeUser = 'lc_user';
  static const String keyCodeforcesUser = 'cf_user';
  static const String keyHapticEnabled = 'haptic_enabled';

  Future<void> saveGitHubCredentials(String username, String token) async {
    await _storage.write(key: keyGithubUser, value: username);
    await _storage.write(key: keyGithubToken, value: token);
  }

  Future<Map<String, String?>> getGitHubCredentials() async {
    return {
      'username': await _storage.read(key: keyGithubUser),
      'token': await _storage.read(key: keyGithubToken),
    };
  }

  Future<void> saveLeetCodeUser(String username) async {
    await _storage.write(key: keyLeetcodeUser, value: username);
  }

  Future<void> saveCodeforcesUser(String username) async {
    await _storage.write(key: keyCodeforcesUser, value: username);
  }

  Future<void> setHapticEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyHapticEnabled, enabled);
  }

  Future<bool> isHapticEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyHapticEnabled) ?? true;
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
