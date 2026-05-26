import 'package:equatable/equatable.dart';
import 'package:guess_it/features/room/domain/entities/room_entity.dart';

/// Enumeración que representa las distintas fases del ciclo de vida de la conexión a una sala.
enum RoomStatus { 
  /// Estado inicial por defecto, sin acción.
  initial, 
  /// Proceso asíncrono en curso (creando o uniéndose).
  loading, 
  /// Operación completada con éxito.
  success, 
  /// Operación fallida por un error.
  error 
}

/// Estado global manejado por el [RoomBloc].
///
/// Contiene la información de la sala actual y el estado de la conexión.
class RoomState extends Equatable {
  /// Fase actual de la operación de sala (carga, éxito, error).
  final RoomStatus status;

  /// La entidad de la sala si la operación fue exitosa, nulo en caso contrario.
  final RoomEntity? room;

  /// Mensaje descriptivo si ocurrió un error en la conexión.
  final String? errorMessage;

  /// Crea una instancia inmutable de [RoomState].
  ///
  /// @param status El estado actual del flujo.
  /// @param room Los datos de la sala conectada.
  /// @param errorMessage El mensaje en caso de fallo.
  const RoomState({
    required RoomStatus status,
    required RoomEntity? room,
    required String? errorMessage,
  })  : status = status,
        room = room,
        errorMessage = errorMessage;

  /// Construye el estado inicial base para el BLoC.
  ///
  /// @return Un [RoomState] limpio y sin conexión.
  factory RoomState.initial() {
    return const RoomState(
      status: RoomStatus.initial,
      room: null,
      errorMessage: null,
    );
  }

  /// Crea una copia del estado actual sobrescribiendo solo las propiedades indicadas.
  ///
  /// @param status Nuevo estado del flujo.
  /// @param room Nueva entidad de la sala.
  /// @param errorMessage Nuevo mensaje de error.
  /// @return Un nuevo [RoomState] actualizado.
  RoomState copyWith({
    RoomStatus? status,
    RoomEntity? room,
    String? errorMessage,
  }) {
    return RoomState(
      status: status ?? this.status,
      room: room ?? this.room,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, room, errorMessage];
}
