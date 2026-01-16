import 'dart:developer' as developer;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/cache/app_cache.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/domain/entities/user_profile.dart';

/// Local data source for user profile
/// Handles reading/writing user profile from/to cache
abstract class UserLocalDataSource {
  Future<void> saveUserProfile(UserProfile userProfile);
  Future<UserProfile?> getUserProfile();
  Future<void> clearUserProfile();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final AppCache appCache;

  UserLocalDataSourceImpl(this.appCache);

  @override
  Future<void> saveUserProfile(UserProfile userProfile) async {
    try {
      developer.log('💾 [USER_CACHE] Saving user profile - ID: ${userProfile.id}, Name: ${userProfile.name}, Email: ${userProfile.email}', name: 'UserLocalDataSource');
      await appCache.saveObject(
        AppConstants.cacheKeyUserProfile,
        userProfile.toJson(),
      );
      developer.log('✅ [USER_CACHE] User profile saved successfully', name: 'UserLocalDataSource');
    } catch (e) {
      developer.log('❌ [USER_CACHE] Failed to save user profile: $e', name: 'UserLocalDataSource');
      throw CacheException('Failed to save user profile: $e');
    }
  }

  @override
  Future<UserProfile?> getUserProfile() async {
    try {
      developer.log('🔍 [USER_CACHE] Getting cached user profile', name: 'UserLocalDataSource');
      final json = await appCache.getObject(AppConstants.cacheKeyUserProfile);
      if (json == null) {
        developer.log('⚠️ [USER_CACHE] No cached user profile found', name: 'UserLocalDataSource');
        return null;
      }
      final userProfile = UserProfile.fromJson(json);
      developer.log('✅ [USER_CACHE] Cached user profile found - ID: ${userProfile.id}, Name: ${userProfile.name}, Email: ${userProfile.email}', name: 'UserLocalDataSource');
      return userProfile;
    } catch (e) {
      developer.log('❌ [USER_CACHE] Failed to get user profile: $e', name: 'UserLocalDataSource');
      throw CacheException('Failed to get user profile: $e');
    }
  }

  @override
  Future<void> clearUserProfile() async {
    try {
      developer.log('🗑️ [USER_CACHE] Clearing user profile from cache', name: 'UserLocalDataSource');
      await appCache.remove(AppConstants.cacheKeyUserProfile);
      developer.log('✅ [USER_CACHE] User profile cleared successfully', name: 'UserLocalDataSource');
    } catch (e) {
      developer.log('❌ [USER_CACHE] Failed to clear user profile: $e', name: 'UserLocalDataSource');
      throw CacheException('Failed to clear user profile: $e');
    }
  }
}

