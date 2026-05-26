import 'package:fpdart/fpdart.dart';
import 'package:guess_it/core/errors/failure.dart';
import 'package:guess_it/features/room/domain/entities/room_entity.dart';
import 'package:guess_it/features/room/domain/repositories/room_repository.dart';

/// Caso de uso responsable de inicializar una nueva sala de espera (Lobby).
///
/// Encapsula la lógica de negocio de crear la sala delegando la ejecución
/// en el [RoomRepository], cumpliendo con el principio de Responsabilidad Única.
class CreateRoomUseCase {
  /// Repositorio inyectado que maneja las operaciones de red.
  final RoomRepository repository;

  /// Crea una instancia de [CreateRoomUseCase].
  ///
  /// @param repository Implementación del repositorio de salas.
  const CreateRoomUseCase({
    required RoomRepository repository,
  }) : repository = repository;

  /// Ejecuta el caso de uso para crear una nueva sala.
  ///
  /// @param hostId El ID del usuario creador (anfitrión).
  /// @return Un [Future] que resuelve a [Either] conteniendo la [RoomEntity] creada o un [Failure].
  Future<Either<Failure, RoomEntity>> call(String hostId) async {
    return await repository.createRoom(hostId);
  }
}
