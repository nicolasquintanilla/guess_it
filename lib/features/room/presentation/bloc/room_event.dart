import 'package:equatable/equatable.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class CreateRoomEvent extends RoomEvent {
  final String hostId;

  const CreateRoomEvent({
    required String hostId,
  }) : hostId = hostId;

  @override
  List<Object?> get props => <Object?>[hostId];
}

class JoinRoomEvent extends RoomEvent {
  final String roomId;
  final String guestId;

  const JoinRoomEvent({
    required String roomId,
    required String guestId,
  })  : roomId = roomId,
        guestId = guestId;

  @override
  List<Object?> get props => <Object?>[roomId, guestId];
}
