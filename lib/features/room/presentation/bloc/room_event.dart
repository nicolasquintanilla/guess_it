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
