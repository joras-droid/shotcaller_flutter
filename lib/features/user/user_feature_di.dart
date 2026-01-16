import 'package:get_it/get_it.dart';
import '../../core/cache/app_cache.dart';
import 'data/datasources/user_local_datasource.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/get_cached_user_usecase.dart';
import 'domain/usecases/save_user_usecase.dart';
import 'presentation/bloc/user_bloc.dart';

/// User feature dependency injection
/// All user-related registrations in ONE file
void registerUserFeature(GetIt getIt) {
  // Data Sources
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(
      getIt<AppCache>(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      getIt<UserLocalDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<GetCachedUserUseCase>(
    () => GetCachedUserUseCase(
      getIt<UserRepository>(),
    ),
  );

  getIt.registerLazySingleton<SaveUserUseCase>(
    () => SaveUserUseCase(
      getIt<UserRepository>(),
    ),
  );

  // BLoCs (Factory because each screen needs its own instance)
  getIt.registerFactory<UserBloc>(
    () => UserBloc(
      getCachedUserUseCase: getIt<GetCachedUserUseCase>(),
      saveUserUseCase: getIt<SaveUserUseCase>(),
    ),
  );
}

