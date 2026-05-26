import 'package:fpdart/fpdart.dart';
import 'package:guess_it/core/errors/failure.dart';
import 'package:guess_it/features/room/domain/entities/room_entity.dart';

/// Contrato abstracto para el repositorio de gestión de salas de espera (Lobbies).
///
/// Define las operaciones base para la creación y unión a salas, manejando
/// internamente las excepciones mediante la clase `Failure`.
abstract class RoomRepository {
  /// Genera una nueva sala en la base de datos asignando al usuario como anfitrión.
  ///
  /// @param hostId El identificador del usuario que crea la sala.
  /// @return Un [Future] que resuelve a un [Either] con un [Failure] en caso de error, o el [RoomEntity] creado con éxito.
  Future<Either<Failure, RoomEntity>> createRoom(String hostId);

  /// Conecta al usuario actual como invitado a una sala existente mediante su código.
  ///
  /// @param roomId El código único (ej. 6 dígitos) de la sala a la que unirse.
  /// @param guestId El identificador del usuario que intenta unirse.
  /// @return Un [Future] que resuelve a un [Either] con un [Failure] en caso de error, o el [RoomEntity] actualizado con éxito.
  Future<Either<Failure, RoomEntity>> joinRoom({
    required String roomId,
    required String guestId,
  });
}
