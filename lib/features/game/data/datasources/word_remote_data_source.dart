import 'package:cloud_firestore/cloud_firestore.dart';

class WordRemoteDataSource {
  final FirebaseFirestore firestore;

  const WordRemoteDataSource({
    required FirebaseFirestore firestore,
  }) : firestore = firestore;

  Future<List<String>> getSystemWords() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = 
          await firestore.collection('dictionary').doc('spanish').get();

      if (snapshot.exists && snapshot.data() != null) {
        final Map<String, dynamic> data = snapshot.data()!;
        final List<dynamic>? wordsArray = data['words'] as List<dynamic>?;
        
        if (wordsArray != null) {
          return wordsArray.map((dynamic e) => e.toString().toUpperCase()).toList();
        }
      }
    } catch (_) {
      // Retorna array de emergencia en caso de fallo de red
    }

    return <String>[
      'PERRO',
      'GATO',
      'MESA',
      'COCHE',
      'FÚTBOL',
      'MONTAÑA',
      'PLAYA',
      'SOL',
      'LUNA',
      'RELOJ'
    ];
  }
}
