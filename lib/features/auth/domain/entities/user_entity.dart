import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String username;
  final bool isGuest;
  final String createdAt;
  final int gamesPlayed;
  final int victories;
  final String avatar;

  const UserEntity({
    required String id,
    required String username,
    required bool isGuest,
    required String createdAt,
    required int gamesPlayed,
    required int victories,
    String avatar = 'default',
  })  : id = id,
        username = username,
        isGuest = isGuest,
        createdAt = createdAt,
        gamesPlayed = gamesPlayed,
        victories = victories,
        avatar = avatar;

  UserEntity copyWith({
    String? id,
    String? username,
    bool? isGuest,
    String? createdAt,
    int? gamesPlayed,
    int? victories,
    String? avatar,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      isGuest: isGuest ?? this.isGuest,
      createdAt: createdAt ?? this.createdAt,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      victories: victories ?? this.victories,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, username, isGuest, createdAt, gamesPlayed, victories, avatar];
}
