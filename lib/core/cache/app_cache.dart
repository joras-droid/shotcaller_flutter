import 'dart:convert';

/// Interface for app cache operations
/// Abstract class allows for different implementations (SharedPreferences, Hive, etc.)
abstract class AppCache {
  /// Save a string value with the given key
  Future<void> saveString(String key, String value);

  /// Get a string value by key, returns null if not found
  Future<String?> getString(String key);

  /// Save an object as JSON string
  Future<void> saveObject(String key, Map<String, dynamic> object);

  /// Get an object from JSON string, returns null if not found
  Future<Map<String, dynamic>?> getObject(String key);

  /// Remove a value by key
  Future<void> remove(String key);

  /// Clear all cached data
  Future<void> clear();
}

/// Extension to convert objects to/from JSON
extension AppCacheJson on AppCache {
  Future<void> saveJson(String key, Map<String, dynamic> json) async {
    await saveString(key, jsonEncode(json));
  }

  Future<Map<String, dynamic>?> getJson(String key) async {
    final jsonString = await getString(key);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}

