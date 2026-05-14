import 'dart:convert';
import 'package:http/http.dart' as http;
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
    on<ResetPasswordEvent>(_onResetPassword);
    on<ReloadUserEvent>(_onReloadUser);
    on<ResetAuthStatusEvent>((ResetAuthStatusEvent event, Emitter<AuthState> emit) {
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
      final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
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
    } catch (_) {
      // Ignore background error
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
      emit(state.copyWith(status: AuthStatus.passwordResetSent));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
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
      (user) {
        // Se eliminó la verificación de Firebase de aquí.
        // El correo de Bienvenida se envía en el AuthRemoteDataSource.
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ));
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

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    final UserEntity? user = state.user;
    if (user == null || user.isGuest) return;

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Obtener datos del usuario autenticado para EmailJS antes de borrarlo
      final User? firebaseUser = FirebaseAuth.instance.currentUser;
      final String email = firebaseUser?.email ?? '';
      final String username = firebaseUser?.displayName ?? user.username;

      // 1. ENVÍO DE CORREO DE DESPEDIDA VÍA EMAILJS
      if (email.isNotEmpty) {
        try {
          final Uri url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
          await http.post(
            url,
            headers: <String, String>{'Content-Type': 'application/json'},
            body: json.encode(<String, dynamic>{
              'service_id': 'service_u1e8bsh',
              'template_id': 'template_zajudvl',
              'user_id': '--bZrse3IJidU83YP',
              'template_params': <String, dynamic>{
                'to_name': username,
                'to_email': email,
              },
            }),
          );
        } catch (e) {
          print('Error EmailJS en BLoC: $e');
        }
      }

      // 2. LIMPIEZA DE DATOS EN FIRESTORE
      final QuerySnapshot<Map<String, dynamic>> hostedGroups = await firestore
          .collection('groups')
          .where('hostId', isEqualTo: user.id)
          .get();

      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in hostedGroups.docs) {
        await doc.reference.delete();
      }

      final QuerySnapshot<Map<String, dynamic>> memberGroups = await firestore
          .collection('groups')
          .where('memberNames', arrayContains: user.username)
          .get();

      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in memberGroups.docs) {
        await doc.reference.update(<String, Object?>{
          'memberNames': FieldValue.arrayRemove(<String>[user.username]),
        });
      }

      await firestore.collection('users').doc(user.id).delete();
      await firebaseUser?.delete();

      emit(AuthState.initial());
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateUsername(
    UpdateUsernameEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user == null || state.user!.isGuest) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(state.user!.id)
          .update(<String, Object?>{'username': event.newUsername});

      final UserEntity updatedUser = state.user!.copyWith(username: event.newUsername);

      emit(state.copyWith(user: updatedUser));
    } catch (_) {
      // Ignore background error
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

      final UserEntity updatedUser = state.user!.copyWith(avatar: event.newAvatar);

      emit(state.copyWith(user: updatedUser));
    } catch (_) {
      // Ignore background error
    }
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
