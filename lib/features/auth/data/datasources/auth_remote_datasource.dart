import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User? user = userCredential.user;
    if (user == null) {
      throw Exception('Login failed: User is null');
    }

    final DocumentSnapshot<Map<String, dynamic>> docSnapshot = await firestore.collection('users').doc(user.uid).get();
    
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
    final UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User? user = userCredential.user;
    if (user == null) {
      throw Exception('Registration failed: User is null');
    }

    await user.updateDisplayName(username);
    await user.reload();

    final String createdAt = DateTime.now().toIso8601String();

    final UserEntity userEntity = UserEntity(
      id: user.uid,
      username: username,
      isGuest: false,
      createdAt: createdAt,
      gamesPlayed: 0,
      victories: 0,
    );

    await firestore.collection('users').doc(user.uid).set({
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
}
