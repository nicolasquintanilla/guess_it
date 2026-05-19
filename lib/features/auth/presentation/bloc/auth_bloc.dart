import 'package:guess_it/core/services/email_service.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guess_it/features/auth/domain/entities/user_entity.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_event.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_state.dart';
import 'package:guess_it/features/auth/domain/usecases/login_host_usecase.dart';
import 'package:guess_it/features/auth/domain/usecases/register_host_usecase.dart';
import 'package:guess_it/features/auth/domain/usecases/play_as_guest_usecase.dart';
import 'package:guess_it/features/auth/domain/usecases/logout_usecase.dart';
import 'package:guess_it/core/utils/network_checker.dart';
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
  }) : loginHostUseCase = loginHostUseCase,
       registerHostUseCase = registerHostUseCase,
       playAsGuestUseCase = playAsGuestUseCase,
       logoutUseCase = logoutUseCase,
       super(AuthState.initial()) {
    on<LoginHostEvent>(_onLoginHost);
    on<RegisterHostEvent>(_onRegisterHost);
    on<PlayAsGuestEvent>(_onPlayAsGuest);
    on<LogoutEvent>(_onLogout);
    on<ResetPasswordEvent>(_onResetPassword);
    on<ReloadUserEvent>(_onReloadUser);
    on<ResetAuthStatusEvent>((
      ResetAuthStatusEvent event,
      Emitter<AuthState> emit,
    ) {
      emit(state.copyWith(status: AuthStatus.initial));
    });
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<UpdateUsernameEvent>(_onUpdateUsername);
    on<UpdateAvatarEvent>(_onUpdateAvatar);
  }

  Future<void> _onReloadUser(
    ReloadUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user == null || state.user!.isGuest) return;
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(state.user!.id)
          .get();
      if (doc.exists) {
        final Map<String, dynamic> data = doc.data()!;
        final UserEntity updatedUser = UserEntity(
          id: state.user!.id,
          username: state.user!.username,
          isGuest: state.user!.isGuest,
          createdAt: state.user!.createdAt,
          gamesPlayed: data['gamesPlayed'] as int? ?? 0,
          victories: data['victories'] as int? ?? 0,
          avatar: data['avatar'] as String? ?? 'default',
        );
        emit(state.copyWith(user: updatedUser));
      }
    } catch (_) {}
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    if (!await NetworkChecker.hasConnection()) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'No hay conexión a internet. Por favor, comprueba tu red.',
      ));
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
      emit(state.copyWith(status: AuthStatus.passwordResetSent));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onLoginHost(
    LoginHostEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    if (!await NetworkChecker.hasConnection()) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'No hay conexión a internet. Por favor, comprueba tu red.',
      ));
      return;
    }
    final result = await loginHostUseCase(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> _onRegisterHost(
    RegisterHostEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    if (!await NetworkChecker.hasConnection()) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'No hay conexión a internet. Por favor, comprueba tu red.',
      ));
      return;
    }
    final result = await registerHostUseCase(
      username: event.username,
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (user) {
        // Fire and forget: Enviar correo de bienvenida
        EmailService.sendWelcomeEmail(
          userEmail: event.email,
          userName: event.username,
        );
        emit(state.copyWith(status: AuthStatus.authenticated, user: user));
      },
    );
  }

  Future<void> _onPlayAsGuest(
    PlayAsGuestEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final result = await playAsGuestUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final result = await logoutUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (_) => emit(AuthState.initial()),
    );
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    if (!await NetworkChecker.hasConnection()) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'No hay conexión a internet. Por favor, comprueba tu red.',
      ));
      return;
    }

    final UserEntity? user = state.user;
    if (user == null || user.isGuest) return;

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final User? firebaseUser = FirebaseAuth.instance.currentUser;

      final String? email = firebaseUser?.email;
      final String? username = state.user?.username;

      // LIMPIEZA DE DATOS EN FIRESTORE
      final QuerySnapshot<Map<String, dynamic>> hostedGroups = await firestore
          .collection('groups')
          .where('hostId', isEqualTo: user.id)
          .get();

      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in hostedGroups.docs) {
        await doc.reference.delete();
      }

      final QuerySnapshot<Map<String, dynamic>> memberGroups = await firestore
          .collection('groups')
          .where('memberNames', arrayContains: user.username)
          .get();

      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in memberGroups.docs) {
        await doc.reference.update(<String, Object?>{
          'memberNames': FieldValue.arrayRemove(<String>[user.username]),
          'memberEmails': FieldValue.arrayRemove(<String>[email ?? '']),
          'memberIds': FieldValue.arrayRemove(<String>[
            user.id,
          ]), // Por si se está usando
        });
      }

      await firestore.collection('users').doc(user.id).delete();
      await firebaseUser?.delete();

      // Si el borrado fue exitoso y no era un invitado:
      if (email != null && username != null && !state.user!.isGuest) {
        EmailService.sendGoodbyeEmail(userEmail: email, userName: username);
      }

      emit(AuthState.initial());
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onUpdateUsername(
    UpdateUsernameEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user == null || state.user!.isGuest) return;
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    if (!await NetworkChecker.hasConnection()) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'No hay conexión a internet. Por favor, comprueba tu red.',
      ));
      return;
    }
    try {
      final QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore
          .instance
          .collection('users')
          .where('username', isEqualTo: event.newUsername)
          .get();

      if (query.docs.isNotEmpty) {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: 'Ese nombre de usuario ya está en uso.',
          ),
        );
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(state.user!.id)
          .update(<String, Object?>{'username': event.newUsername});

      final UserEntity updatedUser = state.user!.copyWith(
        username: event.newUsername,
      );
      emit(
        state.copyWith(
          user: updatedUser,
          status: AuthStatus.authenticated,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onUpdateAvatar(
    UpdateAvatarEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user == null || state.user!.isGuest) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(state.user!.id)
          .update(<String, Object?>{'avatar': event.newAvatar});
      final UserEntity updatedUser = state.user!.copyWith(
        avatar: event.newAvatar,
      );
      emit(state.copyWith(user: updatedUser));
    } catch (_) {}
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
