import 'package:fpdart/fpdart.dart';
import 'package:guess_it/core/errors/failure.dart';
import 'package:guess_it/features/room/domain/entities/room_entity.dart';
import 'package:guess_it/features/room/domain/repositories/room_repository.dart';

class JoinRoomUseCase {
  final RoomRepository repository;

  const JoinRoomUseCase({
    required RoomRepository repository,
  }) : repository = repository;

  Future<Either<Failure, RoomEntity>> call({
    required String roomId,
    required String guestId,
  }) async {
    return await repository.joinRoom(
      roomId: roomId,
      guestId: guestId,
    );
  }
}
