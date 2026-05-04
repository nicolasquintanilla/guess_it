import 'package:flutter/foundation.dart'; // Añadimos esto para kIsWeb
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  // Garantizamos que los bindings de Flutter estén listos
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializamos Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Inicializamos el Service Locator (Inyección de Dependencias)
  await di.init();

  // 3. Inicializamos el almacenamiento local para HydratedBloc (CORREGIDO)
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
  // Aplicando regla estricta: Cero uso de 'super.key' abreviado
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Guess It!',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('¡Guess It! Motor de Autenticación 100% Listo.'),
        ),
      ),
    );
  }
}
