import 'dart:developer' as developer;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart' as failures;
import '../../../../core/result/result.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../../user/domain/repositories/user_repository.dart';

/// Implementation of AuthRepository
/// Coordinates between remote data source and user repository for caching
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final UserRepository userRepository;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.userRepository,
  });

  @override
  Future<Result<void>> sendOtp(String email) async {
    try {
      await remoteDataSource.sendOtp(email);
      return const Success(null);
    } on AuthException catch (e) {
      return Failure(failures.AuthFailure(e.message).message);
    } on ServerException catch (e) {
      return Failure(failures.ServerFailure(e.message).message);
    } catch (e) {
      return Failure(failures.ServerFailure('Unexpected error: $e').message);
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
    bool isPasswordReset = false,
  }) async {
    try {
      // For password reset, we don't need to call verify-otp API
      // We just need to verify the OTP format and return it as token
      if (isPasswordReset) {
        // Validate OTP format (6 digits)
        if (otp.length != 6 || !RegExp(r'^\d{6}$').hasMatch(otp)) {
          return const Failure('Invalid OTP format');
        }
        return Success({'token': otp}); // Use OTP as token for password reset
      }

      // For signup, verify OTP with API (but don't send user details yet)
      final result = await remoteDataSource.verifyOtp(
        email: email,
        otp: otp,
      );

      return Success(result);
    } on AuthException catch (e) {
      return Failure(failures.AuthFailure(e.message).message);
    } on ServerException catch (e) {
      return Failure(failures.ServerFailure(e.message).message);
    } catch (e) {
      return Failure(failures.ServerFailure('Unexpected error: $e').message);
    }
  }

  @override
  Future<Result<UserProfile>> signup({
    required String email,
    required String otp,
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      developer.log('📝 [AUTH] Signup attempt - Email: $email, Name: $name', name: 'AuthRepository');
      // Verify OTP and signup in one call
      final result = await remoteDataSource.verifyOtp(
        email: email,
        otp: otp,
        name: name,
        phone: phone,
        password: password,
      );

      // Extract user data from response
      final userData = result['user'] as Map<String, dynamic>;
      final userProfile = UserProfile.fromJson(userData);
      developer.log('✅ [AUTH] Signup successful - User ID: ${userProfile.id}, Name: ${userProfile.name}', name: 'AuthRepository');

      // Save user profile to cache
      developer.log('💾 [AUTH] Saving user profile to cache', name: 'AuthRepository');
      final saveResult = await userRepository.saveUserProfile(userProfile);
      if (saveResult is Failure<void>) {
        developer.log('⚠️ [AUTH] Signup succeeded but cache failed - ${saveResult.message}', name: 'AuthRepository');
        // Signup succeeded but cache failed - still return success
        return Success(userProfile);
      }
      developer.log('✅ [AUTH] User profile cached successfully', name: 'AuthRepository');

      return Success(userProfile);
    } on AuthException catch (e) {
      developer.log('❌ [AUTH] Signup failed - AuthException: ${e.message}', name: 'AuthRepository');
      return Failure(failures.AuthFailure(e.message).message);
    } on ServerException catch (e) {
      developer.log('❌ [AUTH] Signup failed - ServerException: ${e.message}', name: 'AuthRepository');
      return Failure(failures.ServerFailure(e.message).message);
    } catch (e) {
      developer.log('❌ [AUTH] Signup failed - Unexpected error: $e', name: 'AuthRepository');
      return Failure(failures.ServerFailure('Unexpected error: $e').message);
    }
  }

  @override
  Future<Result<UserProfile>> login(String email, String password) async {
    try {
      developer.log('🔐 [AUTH] Login attempt - Email: $email', name: 'AuthRepository');
      // Call remote data source
      final userProfile = await remoteDataSource.login(email, password);
      developer.log('✅ [AUTH] Login successful - User ID: ${userProfile.id}, Name: ${userProfile.name}', name: 'AuthRepository');

      // Save user profile to cache
      developer.log('💾 [AUTH] Saving user profile to cache', name: 'AuthRepository');
      final saveResult = await userRepository.saveUserProfile(userProfile);
      if (saveResult is Failure<void>) {
        developer.log('⚠️ [AUTH] Login succeeded but cache failed - ${saveResult.message}', name: 'AuthRepository');
        // Login succeeded but cache failed - still return success with user profile
        // Log the cache error but don't fail the login
        return Success(userProfile);
      }
      developer.log('✅ [AUTH] User profile cached successfully', name: 'AuthRepository');

      return Success(userProfile);
    } on AuthException catch (e) {
      developer.log('❌ [AUTH] Login failed - AuthException: ${e.message}', name: 'AuthRepository');
      return Failure(failures.AuthFailure(e.message).message);
    } on ServerException catch (e) {
      developer.log('❌ [AUTH] Login failed - ServerException: ${e.message}', name: 'AuthRepository');
      return Failure(failures.ServerFailure(e.message).message);
    } catch (e) {
      developer.log('❌ [AUTH] Login failed - Unexpected error: $e', name: 'AuthRepository');
      return Failure(failures.ServerFailure('Unexpected error: $e').message);
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String password,
    required String token,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        password: password,
        token: token,
      );
      return const Success(null);
    } on AuthException catch (e) {
      return Failure(failures.AuthFailure(e.message).message);
    } on ServerException catch (e) {
      return Failure(failures.ServerFailure(e.message).message);
    } catch (e) {
      return Failure(failures.ServerFailure('Unexpected error: $e').message);
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      developer.log('🚪 [AUTH] Logout initiated', name: 'AuthRepository');
      // Clear user profile from cache
      developer.log('🗑️ [AUTH] Clearing user profile from cache', name: 'AuthRepository');
      final clearResult = await userRepository.clearUserProfile();
      if (clearResult is Failure<void>) {
        developer.log('❌ [AUTH] Logout failed - Cache clear error: ${clearResult.message}', name: 'AuthRepository');
        return Failure(failures.CacheFailure(clearResult.message).message);
      }

      // TODO: Call logout API endpoint if needed
      // await remoteDataSource.logout();

      developer.log('✅ [AUTH] Logout successful - User profile cleared', name: 'AuthRepository');
      return const Success(null);
    } on CacheException catch (e) {
      developer.log('❌ [AUTH] Logout failed - CacheException: ${e.message}', name: 'AuthRepository');
      return Failure(failures.CacheFailure(e.message).message);
    } catch (e) {
      developer.log('❌ [AUTH] Logout failed - Unexpected error: $e', name: 'AuthRepository');
      return Failure(failures.CacheFailure('Unexpected error: $e').message);
    }
  }
}

