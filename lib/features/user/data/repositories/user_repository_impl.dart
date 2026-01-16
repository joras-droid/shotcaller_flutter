import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart' as failures;
import '../../../../core/result/result.dart';
import '../../../auth/domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';

/// Implementation of UserRepository
class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<Result<void>> saveUserProfile(UserProfile userProfile) async {
    try {
      await localDataSource.saveUserProfile(userProfile);
      return const Success(null);
    } on CacheException catch (e) {
      return Failure(failures.CacheFailure(e.message).message);
    } catch (e) {
      return Failure(failures.CacheFailure('Unexpected error: $e').message);
    }
  }

  @override
  Future<Result<UserProfile?>> getUserProfile() async {
    try {
      final userProfile = await localDataSource.getUserProfile();
      return Success(userProfile);
    } on CacheException catch (e) {
      return Failure(failures.CacheFailure(e.message).message);
    } catch (e) {
      return Failure(failures.CacheFailure('Unexpected error: $e').message);
    }
  }

  @override
  Future<Result<void>> clearUserProfile() async {
    try {
      await localDataSource.clearUserProfile();
      return const Success(null);
    } on CacheException catch (e) {
      return Failure(failures.CacheFailure(e.message).message);
    } catch (e) {
      return Failure(failures.CacheFailure('Unexpected error: $e').message);
    }
  }
}

