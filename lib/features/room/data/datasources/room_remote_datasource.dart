import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guess_it/features/room/domain/entities/room_entity.dart';

abstract class RoomRemoteDataSource {
  Future<RoomEntity> createRoom(String hostId);
  Future<RoomEntity> joinRoom({
    required String roomId,
    required String guestId,
  });
}

class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final FirebaseFirestore firestore;

  const RoomRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : firestore = firestore;

  @override
  Future<RoomEntity> createRoom(String hostId) async {
    final String roomId = _generateShortId(6);
    final String initialStatus = 'waiting_for_guest';

    final RoomEntity roomEntity = RoomEntity(
      roomId: roomId,
      hostId: hostId,
      guestId: null,
      roomStatus: initialStatus,
    );

    await firestore.collection('rooms').doc(roomId).set(<String, dynamic>{
      'roomId': roomId,
      'hostId': hostId,
      'guestId': null,
      'roomStatus': initialStatus,
    });

    return roomEntity;
  }

  @override
  Future<RoomEntity> joinRoom({
    required String roomId,
    required String guestId,
  }) async {
    final DocumentReference<Map<String, dynamic>> roomRef = firestore.collection('rooms').doc(roomId);
    final DocumentSnapshot<Map<String, dynamic>> docSnapshot = await roomRef.get();

    if (!docSnapshot.exists) {
      throw Exception('La sala no existe o el código es incorrecto');
    }

    final Map<String, dynamic> data = docSnapshot.data()!;
    final String currentStatus = data['roomStatus'] as String;

    if (currentStatus != 'waiting_for_guest') {
      throw Exception('La sala ya está llena o en curso');
    }

    final String newStatus = 'in_progress';

    await roomRef.update(<String, dynamic>{
      'guestId': guestId,
      'roomStatus': newStatus,
    });

    return RoomEntity(
      roomId: data['roomId'] as String,
      hostId: data['hostId'] as String,
      guestId: guestId,
      roomStatus: newStatus,
    );
  }

  String _generateShortId(int length) {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random rnd = Random();
    return String.fromCharCodes(
      Iterable<int>.generate(
        length,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ),
    );
  }
}
