import '../../../../core/result/result.dart';
import '../../domain/repositories/auth_repository.dart';

/// Use case for sending OTP
class SendOtpUseCase {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  Future<Result<void>> call(String email) async {
    if (email.isEmpty) {
      return const Failure('Email is required');
    }

    return await repository.sendOtp(email);
  }
}

