import 'package:fpdart/fpdart.dart';
import 'package:guess_it/core/errors/failure.dart';
import 'package:guess_it/features/room/domain/entities/room_entity.dart';
import 'package:guess_it/features/room/domain/repositories/room_repository.dart';
import 'package:guess_it/features/room/data/datasources/room_remote_datasource.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;

  const RoomRepositoryImpl({
    required RoomRemoteDataSource remoteDataSource,
  }) : remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, RoomEntity>> createRoom(String hostId) async {
    try {
      final RoomEntity room = await remoteDataSource.createRoom(hostId);
      return Right(room);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
