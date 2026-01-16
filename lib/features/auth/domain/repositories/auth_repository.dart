import '../entities/user_profile.dart';
import '../../../../core/result/result.dart';

/// Authentication repository interface
/// Defines the contract for authentication operations
abstract class AuthRepository {
  /// Send OTP to email
  Future<Result<void>> sendOtp(String email);

  /// Verify OTP
  /// Returns map with user data and tokens
  Future<Result<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
    bool isPasswordReset = false,
  });

  /// Signup with OTP verification
  Future<Result<UserProfile>> signup({
    required String email,
    required String otp,
    required String name,
    required String phone,
    required String password,
  });

  /// Login with email and password
  /// Returns UserProfile and optional token on success
  Future<Result<UserProfile>> login(String email, String password);

  /// Reset password
  Future<Result<void>> resetPassword({
    required String password,
    required String token,
  });

  /// Logout (clears auth token and user profile)
  Future<Result<void>> logout();
}

