import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guess_it/features/ranking/domain/entities/ranking_entity.dart';

class RankingRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  const RankingRemoteDataSource({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : firestore = firestore,
        auth = auth;

  Future<void> addWinAndPoints({required int points, required bool isVictory}) async {
    final User? currentUser = auth.currentUser;
    if (currentUser == null) {
      return;
    }

    final String uid = currentUser.uid;
    final String hostName = currentUser.displayName ?? 'Jugador Anónimo';
    final String lastPlayedAt = DateTime.now().toIso8601String();

    await firestore.collection('users').doc(uid).set(
      <String, dynamic>{
        'hostName': hostName,
        'gamesPlayed': FieldValue.increment(1),
        'victories': FieldValue.increment(isVictory ? 1 : 0),
        'totalPointsScored': FieldValue.increment(points),
        'lastPlayedAt': lastPlayedAt,
      },
      SetOptions(merge: true),
    );
  }

  Future<List<RankingEntity>> getGlobalRanking() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('users')
        .where('gamesPlayed', isGreaterThanOrEqualTo: 5)
        .orderBy('totalPointsScored', descending: true)
        .limit(50)
        .get();

    return snapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      final Map<String, dynamic> data = doc.data();
      return RankingEntity(
        hostName: data['username'] as String? ?? data['hostName'] as String? ?? 'Desconocido',
        totalMatchesWon: data['totalMatchesWon'] as int? ?? 0,
        totalPointsScored: data['totalPointsScored'] as int? ?? 0,
        gamesPlayed: data['gamesPlayed'] as int? ?? 0,
        victories: data['victories'] as int? ?? 0,
      );
    }).toList();
  }
}
