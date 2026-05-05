import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';
import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/game/presentation/bloc/game_bloc.dart';
import 'features/ranking/data/datasources/ranking_remote_data_source.dart';
import 'features/ranking/data/repositories/ranking_repository_impl.dart';
import 'features/ranking/presentation/bloc/ranking_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await di.init();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationDocumentsDirectory()).path,
          ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
            return di.sl<GameBloc>();
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
            return RankingBloc(
              repository: repository,
            );
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Guess It!',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}
