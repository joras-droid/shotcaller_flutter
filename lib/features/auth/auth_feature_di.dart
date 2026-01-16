import 'package:get_it/get_it.dart';
import '../../core/network/api_client.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/send_otp_usecase.dart';
import 'domain/usecases/verify_otp_usecase.dart';
import 'domain/usecases/signup_usecase.dart';
import 'domain/usecases/reset_password_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'presentation/bloc/auth_bloc.dart';
import '../user/domain/repositories/user_repository.dart';

/// Auth feature dependency injection
/// All auth-related registrations in ONE file
void registerAuthFeature(GetIt getIt) {
  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      getIt<ApiClient>(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      userRepository: getIt<UserRepository>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<SendOtpUseCase>(
    () => SendOtpUseCase(
      getIt<AuthRepository>(),
    ),
  );

  getIt.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(
      getIt<AuthRepository>(),
    ),
  );

  getIt.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(
      getIt<AuthRepository>(),
    ),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      getIt<AuthRepository>(),
    ),
  );

  getIt.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(
      getIt<AuthRepository>(),
    ),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(
      getIt<AuthRepository>(),
    ),
  );

  // BLoCs (Factory because each screen needs its own instance)
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      sendOtpUseCase: getIt<SendOtpUseCase>(),
      verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
      signupUseCase: getIt<SignupUseCase>(),
      resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
    ),
  );
}

