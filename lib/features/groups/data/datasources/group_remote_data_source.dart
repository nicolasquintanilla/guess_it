import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/group_entity.dart';

class GroupRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  const GroupRemoteDataSource({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : firestore = firestore,
        auth = auth;

  Future<String> createGroup(String groupName) async {
    final User? currentUser = auth.currentUser;
    if (currentUser == null) {
      throw Exception('Usuario no autenticado');
    }

    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await firestore.collection('users').doc(currentUser.uid).get();

    if (!userDoc.exists) {
      throw Exception('Usuario no encontrado en la base de datos');
    }

    final String username = userDoc.data()?['username'] as String? ?? 'Desconocido';
    final String joinCode = _generateJoinCode();

    final DocumentReference<Map<String, dynamic>> docRef = await firestore.collection('groups').add(<String, dynamic>{
      'name': groupName,
      'hostId': currentUser.uid,
      'joinCode': joinCode,
      'memberNames': <String>[username],
      'createdAt': DateTime.now().toIso8601String(),
    });

    return docRef.id;
  }

  Future<void> joinGroup(String joinCode) async {
    final User? currentUser = auth.currentUser;
    if (currentUser == null) {
      throw Exception('Usuario no autenticado');
    }

    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await firestore.collection('users').doc(currentUser.uid).get();

    if (!userDoc.exists) {
      throw Exception('Usuario no encontrado en la base de datos');
    }

    final String username = userDoc.data()?['username'] as String? ?? 'Desconocido';

    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('groups')
        .where('joinCode', isEqualTo: joinCode)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('Código de grupo no válido');
    }

    final DocumentSnapshot<Map<String, dynamic>> groupDoc = querySnapshot.docs.first;

    await firestore.collection('groups').doc(groupDoc.id).update(<String, dynamic>{
      'memberNames': FieldValue.arrayUnion(<String>[username]),
    });
  }

  Future<List<GroupEntity>> getUserGroups() async {
    final User? currentUser = auth.currentUser;
    if (currentUser == null) {
      throw Exception('Usuario no autenticado');
    }

    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await firestore.collection('users').doc(currentUser.uid).get();

    if (!userDoc.exists) {
      throw Exception('Usuario no encontrado en la base de datos');
    }

    final String username = userDoc.data()?['username'] as String? ?? 'Desconocido';

    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('groups')
        .where('memberNames', arrayContains: username)
        .get();

    return querySnapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      final Map<String, dynamic> data = doc.data();
      return GroupEntity(
        id: doc.id,
        name: data['name'] as String? ?? '',
        hostId: data['hostId'] as String? ?? '',
        joinCode: data['joinCode'] as String? ?? '',
        memberNames: List<String>.from(data['memberNames'] as List<dynamic>? ?? <String>[]),
        createdAt: data['createdAt'] as String? ?? '',
      );
    }).toList();
  }

  String _generateJoinCode() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final Random rnd = Random();
    String result = '';
    for (int i = 0; i < 6; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }
}
