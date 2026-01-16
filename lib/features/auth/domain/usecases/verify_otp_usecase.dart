import '../../../../core/result/result.dart';
import '../../domain/repositories/auth_repository.dart';

/// Use case for verifying OTP
class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Result<Map<String, dynamic>>> call({
    required String email,
    required String otp,
    bool isPasswordReset = false,
  }) async {
    if (email.isEmpty || otp.isEmpty) {
      return const Failure('Email and OTP are required');
    }

    return await repository.verifyOtp(
      email: email,
      otp: otp,
      isPasswordReset: isPasswordReset,
    );
  }
}

