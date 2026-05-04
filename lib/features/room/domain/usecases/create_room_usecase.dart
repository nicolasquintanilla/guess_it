import 'package:fpdart/fpdart.dart';
import 'package:guess_it/core/errors/failure.dart';
import 'package:guess_it/features/room/domain/entities/room_entity.dart';
import 'package:guess_it/features/room/domain/repositories/room_repository.dart';

class CreateRoomUseCase {
  final RoomRepository repository;

  const CreateRoomUseCase({
    required RoomRepository repository,
  }) : repository = repository;

  Future<Either<Failure, RoomEntity>> call(String hostId) async {
    return await repository.createRoom(hostId);
  }
}
