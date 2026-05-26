import 'package:equatable/equatable.dart';

/// Clase base para todos los eventos del [RoomBloc].
abstract class RoomEvent extends Equatable {
  /// Constructor base.
  const RoomEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Evento para solicitar la creación de una nueva sala de espera.
class CreateRoomEvent extends RoomEvent {
  /// El identificador del usuario que actúa como anfitrión.
  final String hostId;

  /// Crea el evento con el ID del host.
  const CreateRoomEvent({
    required String hostId,
  }) : hostId = hostId;

  @override
  List<Object?> get props => <Object?>[hostId];
}

/// Evento para solicitar unirse a una sala existente mediante su código.
class JoinRoomEvent extends RoomEvent {
  /// El código único (6 dígitos) de la sala destino.
  final String roomId;

  /// El identificador del usuario que desea unirse.
  final String guestId;

  /// Crea el evento con las credenciales necesarias para la conexión.
  const JoinRoomEvent({
    required String roomId,
    required String guestId,
  })  : roomId = roomId,
        guestId = guestId;

  @override
  List<Object?> get props => <Object?>[roomId, guestId];
}
