import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/game/presentation/bloc/game_bloc.dart';
import 'features/game/data/datasources/word_remote_data_source.dart';
import 'features/game/data/repositories/word_repository_impl.dart';
import 'features/ranking/data/datasources/ranking_remote_data_source.dart';
import 'features/ranking/data/repositories/ranking_repository_impl.dart';
import 'features/ranking/presentation/bloc/ranking_bloc.dart';
import 'features/groups/presentation/bloc/group_bloc.dart';
import 'features/groups/data/datasources/group_remote_data_source.dart';
import 'features/groups/data/repositories/group_repository_impl.dart';

/// Punto de entrada principal de la aplicación Guess It.
///
/// Se encarga de inicializar los bindings de Flutter, configurar Firebase,
/// configurar la inyección de dependencias (DI) e inicializar el almacenamiento
/// local para la caché de BLoC (HydratedBloc) antes de arrancar la interfaz gráfica.
void main() async {
  // 1. Asegurar los bindings de Flutter
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
  print('--- DEPURACIÓN: Bindings inicializados ---');

  // 2. Inicializar Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('--- DEPURACIÓN: Firebase inicializado ---');
  } catch (e) {
    print('--- ERROR FATAL EN FIREBASE: $e ---');
  }

  // 3. Inicializar Inyección de Dependencias
  try {
    await di.init();
    print('--- DEPURACIÓN: Dependencias (DI) inicializadas ---');
  } catch (e) {
    print('--- ERROR FATAL EN DI: $e ---');
  }

  // 4. Inicializar Caché (HydratedBloc)
  try {
    print('--- DEPURACIÓN: Buscando directorio de almacenamiento... ---');
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorageDirectory.web
          : HydratedStorageDirectory(
              (await getApplicationDocumentsDirectory()).path,
            ),
    );
    print('--- DEPURACIÓN: HydratedStorage inicializado ---');
  } catch (e) {
    print('--- ERROR FATAL EN HYDRATED STORAGE: $e ---');
  }

  // 5. Arrancar la App
  print('--- DEPURACIÓN: Arrancando runApp... ---');
  runApp(const MyApp());
}

/// Raíz de la jerarquía de widgets de la aplicación.
///
/// Se encarga de proveer globalmente los BLoCs (Auth, Game, Ranking, Group)
/// a todo el árbol de widgets y de configurar el `MaterialApp` con el enrutador
/// y el tema visual base (colores, tipografías, estilos de botones).
class MyApp extends StatelessWidget {
  @override
  final Key? key;

  /// Crea una instancia de [MyApp].
  ///
  /// @param key El identificador opcional para el widget raíz.
  const MyApp({Key? key}) : key = key;

  /// Construye la aplicación inyectando dependencias y configurando el tema.
  ///
  /// @param context El contexto de construcción base.
  /// @return Un [Widget] de tipo `MultiBlocProvider` que envuelve a `MaterialApp.router`.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) {
            return di.sl<AuthBloc>();
          },
        ),
        BlocProvider<GameBloc>(
          create: (BuildContext context) {
            final WordRemoteDataSource wordRemoteDataSource =
                WordRemoteDataSource(firestore: FirebaseFirestore.instance);
            final WordRepositoryImpl wordRepository = WordRepositoryImpl(
              remoteDataSource: wordRemoteDataSource,
            );
            return GameBloc(wordRepository: wordRepository);
          },
        ),
        BlocProvider<RankingBloc>(
          create: (BuildContext context) {
            final RankingRemoteDataSource dataSource = RankingRemoteDataSource(
              firestore: FirebaseFirestore.instance,
              auth: FirebaseAuth.instance,
            );
            final RankingRepositoryImpl repository = RankingRepositoryImpl(
              remoteDataSource: dataSource,
            );
            return RankingBloc(repository: repository);
          },
        ),
        BlocProvider<GroupBloc>(
          create: (BuildContext context) {
            final GroupRemoteDataSource dataSource = GroupRemoteDataSource(
              firestore: FirebaseFirestore.instance,
              auth: FirebaseAuth.instance,
            );
            final GroupRepositoryImpl repository = GroupRepositoryImpl(
              remoteDataSource: dataSource,
            );
            return GroupBloc(repository: repository);
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Guess It',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurpleAccent,
            background: Colors.grey[50],
          ),
          textTheme: GoogleFonts.nunitoTextTheme(),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.deepPurpleAccent,
            ),
            iconTheme: const IconThemeData(color: Colors.deepPurpleAccent),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent,
              side: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
              foregroundColor: Colors.deepPurpleAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
