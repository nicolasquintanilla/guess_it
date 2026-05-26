import 'package:fpdart/fpdart.dart';
import 'package:guess_it/core/errors/failure.dart';
import 'package:guess_it/features/room/domain/entities/room_entity.dart';
import 'package:guess_it/features/room/domain/repositories/room_repository.dart';

/// Caso de uso responsable de conectar a un usuario a una sala de espera existente.
///
/// Abstrae la lógica de unirse a un *Lobby* verificando el código de la sala
/// e insertando el ID del invitado, apoyándose en el [RoomRepository].
class JoinRoomUseCase {
  /// Repositorio inyectado que maneja la persistencia y conexión de la sala.
  final RoomRepository repository;

  /// Crea una instancia de [JoinRoomUseCase].
  ///
  /// @param repository Implementación del repositorio de salas.
  const JoinRoomUseCase({
    required RoomRepository repository,
  }) : repository = repository;

  /// Ejecuta el caso de uso para unirse a una sala específica.
  ///
  /// @param roomId El código de 6 dígitos que identifica la sala.
  /// @param guestId El identificador del usuario que intenta entrar.
  /// @return Un [Future] que resuelve a [Either] con la [RoomEntity] de la sala o un [Failure] si el código no existe o está llena.
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
