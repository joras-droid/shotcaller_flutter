import '../../../../core/result/result.dart';
import '../../../auth/domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';

/// Use case for getting cached user profile
class GetCachedUserUseCase {
  final UserRepository repository;

  GetCachedUserUseCase(this.repository);

  Future<Result<UserProfile?>> call() async {
    return await repository.getUserProfile();
  }
}

