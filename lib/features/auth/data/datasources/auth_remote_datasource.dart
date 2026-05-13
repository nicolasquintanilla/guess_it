import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:guess_it/features/auth/domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity> loginHost({
    required String email,
    required String password,
  });

  Future<UserEntity> registerHost({
    required String username,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  const AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : firebaseAuth = firebaseAuth,
       firestore = firestore;

  @override
  Future<UserEntity> loginHost({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    final User? user = userCredential.user;
    if (user == null) {
      throw Exception('Login failed: User is null');
    }

    final DocumentSnapshot<Map<String, dynamic>> docSnapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!docSnapshot.exists) {
      throw Exception('User data not found in Firestore');
    }

    final Map<String, dynamic> data = docSnapshot.data()!;

    return UserEntity(
      id: user.uid,
      username: data['username'] as String,
      isGuest: data['isGuest'] as bool,
      createdAt: data['createdAt'] as String,
      gamesPlayed: data['gamesPlayed'] as int? ?? 0,
      victories: data['victories'] as int? ?? 0,
    );
  }

  @override
  Future<UserEntity> registerHost({
    required String username,
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    final User? user = userCredential.user;
    if (user == null) {
      throw Exception('Registration failed: User is null');
    }

    await user.updateDisplayName(username);
    await user.reload();

    // CORREO DE BIENVENIDA VÍA EMAILJS
    try {
      final Uri url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      await http.post(
        url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(<String, dynamic>{
          'service_id': 'service_u1e8bsh',
          'template_id': 'template_th5cpeq',
          'user_id': '--bZrse3IJidU83YP',
          'template_params': <String, dynamic>{
            'to_name': username,
            'to_email': email,
          },
        }),
      );
    } catch (e) {
      print('Error enviando bienvenida de EmailJS: $e');
    }

    final String createdAt = DateTime.now().toIso8601String();

    final UserEntity userEntity = UserEntity(
      id: user.uid,
      username: username,
      isGuest: false,
      createdAt: createdAt,
      gamesPlayed: 0,
      victories: 0,
    );

    await firestore.collection('users').doc(user.uid).set(<String, dynamic>{
      'username': username,
      'isGuest': false,
      'createdAt': createdAt,
      'gamesPlayed': 0,
      'victories': 0,
    });

    return userEntity;
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    final User? user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    final String email = user.email ?? '';
    final String username = user.displayName ?? 'Jugador';
    final String uid = user.uid;

    // 2. ENVÍO DE CORREO DE DESPEDIDA VÍA EMAILJS
    if (email.isNotEmpty) {
      try {
        final Uri url = Uri.parse(
          'https://api.emailjs.com/api/v1.0/email/send',
        );
        await http.post(
          url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            'service_id': 'service_u1e8bsh',
            'template_id': 'template_zajudvl',
            'user_id': '--bZrse3IJidU83YP',
            'template_params': <String, dynamic>{
              'to_name': username,
              'to_email': email,
            },
          }),
        );
      } catch (e) {
        print('Error enviando correo de despedida: $e');
      }
    }

    // 3. LIMPIEZA DE DATOS
    try {
      await firestore.collection('users').doc(uid).delete();
    } catch (e) {
      print('Error borrando documento de Firestore: $e');
    }

    await user.delete();
  }
}
