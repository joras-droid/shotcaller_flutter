import '../../../../core/result/result.dart';
import '../../../auth/domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';

/// Use case for saving user profile
class SaveUserUseCase {
  final UserRepository repository;

  SaveUserUseCase(this.repository);

  Future<Result<void>> call(UserProfile userProfile) async {
    return await repository.saveUserProfile(userProfile);
  }
}

