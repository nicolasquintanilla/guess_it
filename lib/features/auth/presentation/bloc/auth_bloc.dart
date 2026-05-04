import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_event.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_state.dart';
import 'package:guess_it/features/auth/domain/usecases/login_host_usecase.dart';
import 'package:guess_it/features/auth/domain/usecases/register_host_usecase.dart';
import 'package:guess_it/features/auth/domain/usecases/play_as_guest_usecase.dart';
import 'package:guess_it/features/auth/domain/usecases/logout_usecase.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final LoginHostUseCase loginHostUseCase;
  final RegisterHostUseCase registerHostUseCase;
  final PlayAsGuestUseCase playAsGuestUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required LoginHostUseCase loginHostUseCase,
    required RegisterHostUseCase registerHostUseCase,
    required PlayAsGuestUseCase playAsGuestUseCase,
    required LogoutUseCase logoutUseCase,
  })  : loginHostUseCase = loginHostUseCase,
        registerHostUseCase = registerHostUseCase,
        playAsGuestUseCase = playAsGuestUseCase,
        logoutUseCase = logoutUseCase,
        super(AuthState.initial()) {
    on<LoginHostEvent>(_onLoginHost);
    on<RegisterHostEvent>(_onRegisterHost);
    on<PlayAsGuestEvent>(_onPlayAsGuest);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLoginHost(
    LoginHostEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final result = await loginHostUseCase(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      )),
    );
  }

  Future<void> _onRegisterHost(
    RegisterHostEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final result = await registerHostUseCase(
      username: event.username,
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      )),
    );
  }

  Future<void> _onPlayAsGuest(
    PlayAsGuestEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final result = await playAsGuestUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      )),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final result = await logoutUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(AuthState.initial()),
    );
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.toJson();
  }
}
