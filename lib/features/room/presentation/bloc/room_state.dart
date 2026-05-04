import 'package:equatable/equatable.dart';
import 'package:guess_it/features/room/domain/entities/room_entity.dart';

enum RoomStatus { initial, loading, success, error }

class RoomState extends Equatable {
  final RoomStatus status;
  final RoomEntity? room;
  final String? errorMessage;

  const RoomState({
    required RoomStatus status,
    required RoomEntity? room,
    required String? errorMessage,
  })  : status = status,
        room = room,
        errorMessage = errorMessage;

  factory RoomState.initial() {
    return const RoomState(
      status: RoomStatus.initial,
      room: null,
      errorMessage: null,
    );
  }

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
