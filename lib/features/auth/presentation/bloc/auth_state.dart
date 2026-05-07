import 'package:equatable/equatable.dart';
import 'package:guess_it/features/auth/domain/entities/user_entity.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const AuthState({
    required AuthStatus status,
    required UserEntity? user,
    required String? errorMessage,
  }) : status = status,
       user = user,
       errorMessage = errorMessage;

  factory AuthState.initial() {
    return const AuthState(
      status: AuthStatus.initial,
      user: null,
      errorMessage: null,
    );
  }

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, user, errorMessage];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'status': status.name,
      'user': user != null
          ? <String, dynamic>{
              'id': user!.id,
              'username': user!.username,
              'isGuest': user!.isGuest,
              'createdAt': user!.createdAt,
              'gamesPlayed': user!.gamesPlayed,
              'victories': user!.victories,
            }
          : null,
      'errorMessage': errorMessage,
    };
  }

  factory AuthState.fromJson(Map<String, dynamic> json) {
    return AuthState(
      status: AuthStatus.values.firstWhere(
        (AuthStatus element) => element.name == json['status'],
        orElse: () => AuthStatus.initial,
      ),
      user: json['user'] != null
          ? UserEntity(
              id: json['user']['id'] as String,
              username: json['user']['username'] as String,
              isGuest: json['user']['isGuest'] as bool,
              createdAt: json['user']['createdAt'] as String,
              gamesPlayed: json['user']['gamesPlayed'] as int? ?? 0,
              victories: json['user']['victories'] as int? ?? 0,
            )
          : null,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}
