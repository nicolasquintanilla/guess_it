import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:guess_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:guess_it/features/auth/domain/usecases/login_host_usecase.dart';
import 'package:guess_it/features/auth/domain/usecases/register_host_usecase.dart';
import 'package:guess_it/features/auth/domain/usecases/play_as_guest_usecase.dart';
import 'package:guess_it/features/auth/domain/usecases/logout_usecase.dart';
import 'package:guess_it/features/auth/domain/repositories/auth_repository.dart';
import 'package:guess_it/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:guess_it/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:guess_it/features/auth/data/datasources/auth_local_datasource.dart';

import 'package:guess_it/features/room/presentation/bloc/room_bloc.dart';
import 'package:guess_it/features/room/domain/usecases/create_room_usecase.dart';
import 'package:guess_it/features/room/domain/repositories/room_repository.dart';
import 'package:guess_it/features/room/data/repositories/room_repository_impl.dart';
import 'package:guess_it/features/room/data/datasources/room_remote_datasource.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginHostUseCase: sl(),
      registerHostUseCase: sl(),
      playAsGuestUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => RoomBloc(
      createRoomUseCase: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(
    () => LoginHostUseCase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => RegisterHostUseCase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => PlayAsGuestUseCase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => LogoutUseCase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => CreateRoomUseCase(
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<RoomRepository>(
    () => RoomRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      uuid: sl(),
    ),
  );
  sl.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSourceImpl(
      firestore: sl(),
    ),
  );

  // Core/Externos
  sl.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );
  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  sl.registerLazySingleton<Uuid>(
    () => const Uuid(),
  );
}
