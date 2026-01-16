import '../../../../core/result/result.dart';
import '../../domain/repositories/auth_repository.dart';

/// Use case for user logout
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Result<void>> call() async {
    return await repository.logout();
  }
}

