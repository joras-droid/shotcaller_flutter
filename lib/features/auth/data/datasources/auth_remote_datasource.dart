import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/user_profile.dart';

/// Remote data source for authentication
/// Handles API calls for login/logout, OTP, signup, password reset
abstract class AuthRemoteDataSource {
  Future<void> sendOtp(String email);
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
    String? name,
    String? phone,
    String? password,
  });
  Future<UserProfile> login(String email, String password);
  Future<void> resetPassword({required String password, required String token});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<void> sendOtp(String email) async {
    try {
      final response = await apiClient.dio.post(
        AppConstants.apiSendOtpEndpoint,
        data: {'email': email},
      );

      final data = response.data as Map<String, dynamic>;
      // Response: {"message": "OTP has been sent to your email", "email": "user@example.com"}
      if (data['message'] == null) {
        throw AuthException('Failed to send OTP');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] as String? ??
            'Failed to send OTP';
        throw AuthException(message);
      } else {
        throw ServerException('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is AuthException || e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
    String? name,
    String? phone,
    String? password,
  }) async {
    try {
      final data = <String, dynamic>{
        'email': email,
        'otp': otp,
      };

      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (password != null) data['password'] = password;

      final response = await apiClient.dio.post(
        AppConstants.apiVerifyOtpEndpoint,
        data: data,
      );

      // Response contains user, accessToken, refreshToken
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] as String? ??
            'OTP verification failed';
        throw AuthException(message);
      } else {
        throw ServerException('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is AuthException || e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<UserProfile> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        AppConstants.apiLoginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final userData = data['user'] as Map<String, dynamic>;
      // final accessToken = data['accessToken'] as String?;
      // final refreshToken = data['refreshToken'] as String?;

      // TODO: Store tokens securely using flutter_secure_storage
      // if (accessToken != null) {
      //   await secureStorage.write(key: AppConstants.cacheKeyAuthToken, value: accessToken);
      // }
      // if (refreshToken != null) {
      //   await secureStorage.write(key: AppConstants.cacheKeyRefreshToken, value: refreshToken);
      // }

      return UserProfile.fromJson(userData);
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] as String? ??
            'Authentication failed';
        throw AuthException(message);
      } else {
        throw ServerException('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is AuthException || e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> resetPassword({
    required String password,
    required String token,
  }) async {
    try {
      final response = await apiClient.dio.post(
        AppConstants.apiPasswordResetEndpoint,
        data: {
          'password': password,
          'token': token,
        },
      );

      final data = response.data as Map<String, dynamic>;
      if (data['message'] == null) {
        throw AuthException('Failed to reset password');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] as String? ??
            'Failed to reset password';
        throw AuthException(message);
      } else {
        throw ServerException('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is AuthException || e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error: $e');
    }
  }
}

