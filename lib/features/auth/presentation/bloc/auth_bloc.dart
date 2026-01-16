import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer' as developer;
import '../../../../core/result/result.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

/// Auth Events
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class SendOtpRequested extends AuthEvent {
  final String email;

  const SendOtpRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

final class VerifyOtpRequested extends AuthEvent {
  final String email;
  final String otp;
  final bool isPasswordReset;

  const VerifyOtpRequested({
    required this.email,
    required this.otp,
    this.isPasswordReset = false,
  });

  @override
  List<Object?> get props => [email, otp, isPasswordReset];
}

final class SignupRequested extends AuthEvent {
  final String email;
  final String otp;
  final String name;
  final String phone;
  final String password;

  const SignupRequested({
    required this.email,
    required this.otp,
    required this.name,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [email, otp, name, phone, password];
}

final class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

final class ResetPasswordRequested extends AuthEvent {
  final String password;
  final String token;

  const ResetPasswordRequested({
    required this.password,
    required this.token,
  });

  @override
  List<Object?> get props => [password, token];
}

final class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

final class RestoreAuthState extends AuthEvent {
  final UserProfile userProfile;

  const RestoreAuthState(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

/// Auth States
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  final UserProfile userProfile;

  const AuthAuthenticated(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

final class OtpSent extends AuthState {
  final String email;

  const OtpSent(this.email);

  @override
  List<Object?> get props => [email];
}

final class OtpVerified extends AuthState {
  final String? token;

  const OtpVerified({this.token});

  @override
  List<Object?> get props => [token];
}

final class PasswordResetSuccess extends AuthState {
  const PasswordResetSuccess();
}

/// Auth BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final SignupUseCase signupUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.signupUseCase,
    required this.resetPasswordUseCase,
    required this.logoutUseCase,
  }) : super(const AuthInitial()) {
    on<SendOtpRequested>(_onSendOtpRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LoginRequested>(_onLoginRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<RestoreAuthState>(_onRestoreAuthState);
  }

  Future<void> _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await sendOtpUseCase(event.email);

    result.when(
      success: (_) => emit(OtpSent(event.email)),
      failure: (message) => emit(AuthError(message)),
    );
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await verifyOtpUseCase(
      email: event.email,
      otp: event.otp,
      isPasswordReset: event.isPasswordReset,
    );

    result.when(
      success: (data) {
        final token = data['token'] as String?;
        emit(OtpVerified(token: token));
      },
      failure: (message) => emit(AuthError(message)),
    );
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signupUseCase(
      email: event.email,
      otp: event.otp,
      name: event.name,
      phone: event.phone,
      password: event.password,
    );

    result.when(
      success: (userProfile) => emit(AuthAuthenticated(userProfile)),
      failure: (message) => emit(AuthError(message)),
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginUseCase(event.email, event.password);

    result.when(
      success: (userProfile) => emit(AuthAuthenticated(userProfile)),
      failure: (message) => emit(AuthError(message)),
    );
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await resetPasswordUseCase(
      password: event.password,
      token: event.token,
    );

    result.when(
      success: (_) => emit(const PasswordResetSuccess()),
      failure: (message) => emit(AuthError(message)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await logoutUseCase();

    result.when(
      success: (_) => emit(const AuthUnauthenticated()),
      failure: (message) => emit(AuthError(message)),
    );
  }

  void _onRestoreAuthState(
    RestoreAuthState event,
    Emitter<AuthState> emit,
  ) {
    developer.log('🔄 [AUTH_BLOC] Restoring auth state from cached user - ID: ${event.userProfile.id}', name: 'AuthBloc');
    emit(AuthAuthenticated(event.userProfile));
  }
}

