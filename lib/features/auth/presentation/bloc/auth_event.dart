import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginHostEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginHostEvent({
    required String email,
    required String password,
  })  : email = email,
        password = password;

  @override
  List<Object?> get props => [email, password];
}

class RegisterHostEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const RegisterHostEvent({
    required String username,
    required String email,
    required String password,
  })  : username = username,
        email = email,
        password = password;

  @override
  List<Object?> get props => [username, email, password];
}

class PlayAsGuestEvent extends AuthEvent {
  const PlayAsGuestEvent();
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}
