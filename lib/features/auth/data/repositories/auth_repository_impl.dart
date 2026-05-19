import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:guess_it/core/errors/failure.dart';
import 'package:guess_it/features/auth/domain/entities/user_entity.dart';
import 'package:guess_it/features/auth/domain/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guess_it/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:guess_it/features/auth/data/datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : remoteDataSource = remoteDataSource,
       localDataSource = localDataSource;

  String _mapFirebaseError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Este correo ya está registrado.';
        case 'weak-password':
          return 'La contraseña es demasiado débil. Usa al menos 6 caracteres.';
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          return 'Correo o contraseña incorrectos.';
        case 'permission-denied':
          return 'Error de permisos al crear la cuenta. Inténtalo de nuevo.';
        default:
          return 'Ha ocurrido un error inesperado. Por favor, inténtalo más tarde.';
      }
    } else if (e is FirebaseException) {
      if (e.code == 'permission-denied') {
        return 'Error de permisos al crear la cuenta. Inténtalo de nuevo.';
      }
      return 'Ha ocurrido un error inesperado. Por favor, inténtalo más tarde.';
    }
    return 'Ha ocurrido un error inesperado. Por favor, inténtalo más tarde.';
  }

  @override
  Future<Either<Failure, UserEntity>> loginHost({
    required String email,
    required String password,
  }) async {
    try {
      final UserEntity user = await remoteDataSource.loginHost(
        email: email,
        password: password,
      );
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: _mapFirebaseError(e)));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerHost({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> userQuery =
          await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: username)
              .get();

      if (userQuery.docs.isNotEmpty) {
        return const Left(
          ServerFailure(
            message:
                'El nombre de usuario ya está en uso. Por favor, elige otro.',
          ),
        );
      }

      final UserEntity user = await remoteDataSource.registerHost(
        username: username,
        email: email,
        password: password,
      );
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: _mapFirebaseError(e)));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> playAsGuest() async {
    try {
      final UserEntity user = await localDataSource.playAsGuest();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
