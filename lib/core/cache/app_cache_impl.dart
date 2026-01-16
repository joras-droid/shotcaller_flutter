import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import 'app_cache.dart';

/// SharedPreferences implementation of AppCache
/// Using SharedPreferences: Simple, reliable, and sufficient for user profile data.
/// Hive would be overkill for simple key-value storage of user profile.
class AppCacheImpl implements AppCache {
  final SharedPreferences _prefs;

  AppCacheImpl(this._prefs);

  @override
  Future<void> saveString(String key, String value) async {
    developer.log('🔵 [CACHE] Saving string - Key: $key, Value: $value', name: 'AppCache');
    await _prefs.setString(key, value);
    developer.log('✅ [CACHE] String saved successfully - Key: $key', name: 'AppCache');
  }

  @override
  Future<String?> getString(String key) async {
    developer.log('🔵 [CACHE] Getting string - Key: $key', name: 'AppCache');
    final value = _prefs.getString(key);
    developer.log('${value != null ? "✅" : "⚠️"} [CACHE] String ${value != null ? "found" : "not found"} - Key: $key, Value: ${value ?? "null"}', name: 'AppCache');
    return value;
  }

  @override
  Future<void> saveObject(String key, Map<String, dynamic> object) async {
    developer.log('🔵 [CACHE] Saving object - Key: $key, Data: $object', name: 'AppCache');
    await saveJson(key, object);
    developer.log('✅ [CACHE] Object saved successfully - Key: $key', name: 'AppCache');
  }

  @override
  Future<Map<String, dynamic>?> getObject(String key) async {
    developer.log('🔵 [CACHE] Getting object - Key: $key', name: 'AppCache');
    final json = await getJson(key);
    developer.log('${json != null ? "✅" : "⚠️"} [CACHE] Object ${json != null ? "found" : "not found"} - Key: $key, Data: ${json ?? "null"}', name: 'AppCache');
    return json;
  }

  @override
  Future<void> remove(String key) async {
    developer.log('🔵 [CACHE] Removing - Key: $key', name: 'AppCache');
    await _prefs.remove(key);
    developer.log('✅ [CACHE] Removed successfully - Key: $key', name: 'AppCache');
  }

  @override
  Future<void> clear() async {
    developer.log('🔵 [CACHE] Clearing all cache', name: 'AppCache');
    await _prefs.clear();
    developer.log('✅ [CACHE] All cache cleared', name: 'AppCache');
  }
}

