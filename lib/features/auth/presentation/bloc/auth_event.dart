import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => <Object?>[];
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
  List<Object?> get props => <Object?>[email, password];
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
  List<Object?> get props => <Object?>[username, email, password];
}

class PlayAsGuestEvent extends AuthEvent {
  const PlayAsGuestEvent();
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  const ResetPasswordEvent({
    required String email,
  }) : email = email;

  @override
  List<Object?> get props => <Object?>[email];
}

class ResetAuthStatusEvent extends AuthEvent {
  const ResetAuthStatusEvent();
}

class ReloadUserEvent extends AuthEvent {
  const ReloadUserEvent();
}

class DeleteAccountEvent extends AuthEvent {
  const DeleteAccountEvent();
}

class UpdateUsernameEvent extends AuthEvent {
  final String newUsername;
  
  const UpdateUsernameEvent({
    required String newUsername,
  }) : newUsername = newUsername;

  @override
  List<Object?> get props => <Object?>[newUsername];
}

class UpdateAvatarEvent extends AuthEvent {
  final String newAvatar;
  
  const UpdateAvatarEvent({
    required String newAvatar,
  }) : newAvatar = newAvatar;

  @override
  List<Object?> get props => <Object?>[newAvatar];
}
