import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailjs/emailjs.dart' as emailjs;
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

    final String createdAt = DateTime.now().toIso8601String();

    // 1. PRIMERO: Guardamos en Firestore inmediatamente para aprovechar el token
    await firestore.collection('users').doc(user.uid).set(<String, dynamic>{
      'username': username,
      'email': email.toLowerCase(),
      'isGuest': false,
      'gamesPlayed': 0,
      'victories': 0,
      'totalPointsScored': 0,
      'avatar': 'none',
      'createdAt': createdAt,
    });

    // 2. SEGUNDO: Actualizamos el perfil de Firebase Auth
    await user.updateDisplayName(username);

    // 3. TERCERO: Envío de EmailJS en modo "fuego y olvido" (sin await)
    // Usamos .timeout() para que si falla la red, no bloquee la app.
    emailjs
        .send(
          'service_u1e8bsh',
          'template_th5cpeq',
          <String, dynamic>{'to_name': username, 'to_email': email},
          const emailjs.Options(publicKey: '--bZrse3IJidU83YP', privateKey: ''),
        )
        .timeout(const Duration(seconds: 5))
        .then((_) {
          print('BIENVENIDA ENVIADA CON ÉXITO');
        })
        .catchError((error) {
          print('Error asíncrono de EmailJS ignorado: $error');
        });

    return UserEntity(
      id: user.uid,
      username: username,
      isGuest: false,
      createdAt: createdAt,
      gamesPlayed: 0,
      victories: 0,
    );
  }

  @override
  Future<void> logout() async {
    // 1. Cerramos la sesión en Auth
    await firebaseAuth.signOut();

    // 2. Matamos la instancia de Firestore y limpiamos la caché
    // Esto evita el error de permisos al registrar una cuenta nueva tras hacer logout
    try {
      await firestore.terminate();
      await firestore.clearPersistence();
    } catch (e) {
      print('Error al limpiar Firestore durante el logout: $e');
    }
  }

  @override
  Future<void> deleteAccount() async {
  }
}
