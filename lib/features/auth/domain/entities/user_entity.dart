import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String username;
  final bool isGuest;
  final String createdAt;

  const UserEntity({
    required String id,
    required String username,
    required bool isGuest,
    required String createdAt,
  })  : id = id,
        username = username,
        isGuest = isGuest,
        createdAt = createdAt;

  @override
  List<Object?> get props => [id, username, isGuest, createdAt];
}
