import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String username;
  final bool isGuest;
  final String createdAt;
  final int gamesPlayed;
  final int victories;

  const UserEntity({
    required String id,
    required String username,
    required bool isGuest,
    required String createdAt,
    required int gamesPlayed,
    required int victories,
  })  : id = id,
        username = username,
        isGuest = isGuest,
        createdAt = createdAt,
        gamesPlayed = gamesPlayed,
        victories = victories;

  UserEntity copyWith({
    String? id,
    String? username,
    bool? isGuest,
    String? createdAt,
    int? gamesPlayed,
    int? victories,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      isGuest: isGuest ?? this.isGuest,
      createdAt: createdAt ?? this.createdAt,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      victories: victories ?? this.victories,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, username, isGuest, createdAt, gamesPlayed, victories];
}
