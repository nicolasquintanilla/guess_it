import 'package:uuid/uuid.dart';
import 'package:guess_it/features/auth/domain/entities/user_entity.dart';

abstract class AuthLocalDataSource {
  Future<UserEntity> playAsGuest();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Uuid uuid;

  const AuthLocalDataSourceImpl({required Uuid uuid}) : uuid = uuid;

  @override
  Future<UserEntity> playAsGuest() async {
    final String generatedId = uuid.v4();
    final String createdAt = DateTime.now().toIso8601String();

    return UserEntity(
      id: generatedId,
      username: 'Guest_$generatedId',
      isGuest: true,
      createdAt: createdAt,
      gamesPlayed: 0,
      victories: 0,
    );
  }
}
