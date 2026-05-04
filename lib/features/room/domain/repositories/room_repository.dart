import 'package:fpdart/fpdart.dart';
import 'package:guess_it/core/errors/failure.dart';
import 'package:guess_it/features/room/domain/entities/room_entity.dart';

abstract class RoomRepository {
  Future<Either<Failure, RoomEntity>> createRoom(String hostId);
}
