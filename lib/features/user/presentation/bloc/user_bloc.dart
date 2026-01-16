import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/result/result.dart';
import '../../../auth/domain/entities/user_profile.dart';
import '../../domain/usecases/get_cached_user_usecase.dart';
import '../../domain/usecases/save_user_usecase.dart';

/// User Events
sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

final class LoadCachedUser extends UserEvent {
  const LoadCachedUser();
}

final class SaveUser extends UserEvent {
  final UserProfile userProfile;

  const SaveUser(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

final class ClearUser extends UserEvent {
  const ClearUser();
}

/// User States
sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

final class UserInitial extends UserState {
  const UserInitial();
}

final class UserLoading extends UserState {
  const UserLoading();
}

final class UserLoaded extends UserState {
  final UserProfile? userProfile;

  const UserLoaded(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

final class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

/// User BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetCachedUserUseCase getCachedUserUseCase;
  final SaveUserUseCase saveUserUseCase;

  UserBloc({
    required this.getCachedUserUseCase,
    required this.saveUserUseCase,
  }) : super(const UserInitial()) {
    on<LoadCachedUser>(_onLoadCachedUser);
    on<SaveUser>(_onSaveUser);
    on<ClearUser>(_onClearUser);
  }

  Future<void> _onLoadCachedUser(
    LoadCachedUser event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());
    developer.log('🔍 [USER_BLOC] Loading cached user profile', name: 'UserBloc');

    final result = await getCachedUserUseCase();

    result.when(
      success: (userProfile) {
        developer.log('${userProfile != null ? "✅" : "⚠️"} [USER_BLOC] Cached user ${userProfile != null ? "found" : "not found"} - ${userProfile != null ? "ID: ${userProfile.id}, Name: ${userProfile.name}" : ""}', name: 'UserBloc');
        emit(UserLoaded(userProfile));
      },
      failure: (message) {
        developer.log('❌ [USER_BLOC] Failed to load cached user - $message', name: 'UserBloc');
        emit(UserError(message));
      },
    );
  }

  Future<void> _onSaveUser(
    SaveUser event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());
    developer.log('💾 [USER_BLOC] Saving user profile - ID: ${event.userProfile.id}, Name: ${event.userProfile.name}', name: 'UserBloc');

    final result = await saveUserUseCase(event.userProfile);

    result.when(
      success: (_) {
        developer.log('✅ [USER_BLOC] User profile saved successfully', name: 'UserBloc');
        emit(UserLoaded(event.userProfile));
      },
      failure: (message) {
        developer.log('❌ [USER_BLOC] Failed to save user profile - $message', name: 'UserBloc');
        emit(UserError(message));
      },
    );
  }

  Future<void> _onClearUser(
    ClearUser event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    // TODO: Call clear use case when implemented
    emit(const UserLoaded(null));
  }
}

