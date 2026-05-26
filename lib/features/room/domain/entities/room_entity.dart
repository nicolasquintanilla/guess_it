import 'package:equatable/equatable.dart';

/// Representa una sala de espera o *Lobby* antes de iniciar una partida.
///
/// Gestiona la conexión entre el usuario anfitrión (quien crea la sala)
/// y el invitado (quien se une).
class RoomEntity extends Equatable {
  /// Identificador único de la sala, generalmente un código corto de 6 dígitos.
  final String roomId;

  /// El ID del usuario que creó la sala (anfitrión).
  final String hostId;

  /// El ID del usuario que se ha unido a la sala (opcional, null si está vacía).
  final String? guestId;

  /// El estado actual de la sala (ej. 'waiting', 'starting', 'playing').
  final String roomStatus;

  /// Crea una instancia de [RoomEntity].
  ///
  /// @param roomId El identificador de la sala.
  /// @param hostId El creador de la sala.
  /// @param guestId El usuario unido (si lo hay).
  /// @param roomStatus El estado del flujo de la sala.
  const RoomEntity({
    required String roomId,
    required String hostId,
    required String? guestId,
    required String roomStatus,
  })  : roomId = roomId,
        hostId = hostId,
        guestId = guestId,
        roomStatus = roomStatus;

  @override
  List<Object?> get props => <Object?>[roomId, hostId, guestId, roomStatus];
}
