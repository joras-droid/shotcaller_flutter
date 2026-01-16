import '../../../../core/result/result.dart';
import '../../../auth/domain/entities/user_profile.dart';

/// User repository interface
/// Defines the contract for user profile operations
abstract class UserRepository {
  /// Save user profile to cache
  Future<Result<void>> saveUserProfile(UserProfile userProfile);

  /// Get cached user profile
  Future<Result<UserProfile?>> getUserProfile();

  /// Clear user profile from cache
  Future<Result<void>> clearUserProfile();
}

