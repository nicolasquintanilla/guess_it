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

import 'package:guess_it/features/game/presentation/bloc/game_bloc.dart';
import 'package:guess_it/features/game/domain/repositories/word_repository.dart';
import 'package:guess_it/features/game/data/repositories/word_repository_impl.dart';
import 'package:guess_it/features/game/data/datasources/word_remote_data_source.dart';

/// Instancia global de [GetIt] utilizada como Service Locator (contenedor de inyección de dependencias).
final GetIt sl = GetIt.instance;

/// Inicializa e inyecta todas las dependencias de la aplicación.
///
/// Registra BLoCs, Casos de Uso, Repositorios, DataSources y servicios externos
/// en el contenedor [GetIt] para permitir el patrón de Inyección de Dependencias.
///
/// @return Un [Future] que se completa cuando todas las dependencias están registradas.
Future<void> init() async {
  // --- BLoC ---
  sl.registerFactory(
    () => AuthBloc(
      loginHostUseCase: sl(),
      registerHostUseCase: sl(),
      playAsGuestUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );
  sl.registerFactory(() => GameBloc(wordRepository: sl()));

  // --- UseCases ---
  sl.registerLazySingleton(() => LoginHostUseCase(repository: sl()));
  sl.registerLazySingleton(() => RegisterHostUseCase(repository: sl()));
  sl.registerLazySingleton(() => PlayAsGuestUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(repository: sl()));

  // --- Repository ---
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<WordRepository>(
    () => WordRepositoryImpl(remoteDataSource: sl()),
  );

  // --- DataSources ---
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(uuid: sl()),
  );
  sl.registerLazySingleton<WordRemoteDataSource>(
    () => WordRemoteDataSource(firestore: sl()),
  );

  // --- Core/Externos ---
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<Uuid>(() => const Uuid());
}
