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
  })  : firebaseAuth = firebaseAuth,
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

    // ENVÍO OFICIAL DE EMAILJS
    try {
      await emailjs.send(
        'service_u1e8bsh',
        'template_th5cpeq',
        <String, dynamic>{
          'to_name': username,
          'to_email': email,
        },
        const emailjs.Options(
          publicKey: '--bZrse3IJidU83YP',
          privateKey: '',
        ),
      );
      print('BIENVENIDA ENVIADA CON ÉXITO');
    } catch (error) {
      print('Error fatal de EmailJS en Registro: $error');
    }

    final String createdAt = DateTime.now().toIso8601String();

    await firestore.collection('users').doc(user.uid).set(<String, dynamic>{
      'username': username,
      'isGuest': false,
      'createdAt': createdAt,
      'gamesPlayed': 0,
      'victories': 0,
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
    await firebaseAuth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    // El borrado ahora se maneja enteramente en AuthBloc.
    // Este método se mantiene por contrato de la interfaz,
    // pero la lógica pesada está en el BLoC.
  }
}
