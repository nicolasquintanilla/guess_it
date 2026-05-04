import 'package:equatable/equatable.dart';

class RoomEntity extends Equatable {
  final String roomId;
  final String hostId;
  final String? guestId;
  final String roomStatus;

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
