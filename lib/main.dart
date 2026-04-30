import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Garantizamos que los bindings de Flutter estén listos antes de llamar a código nativo
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos Firebase con el archivo autogenerado
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        body: Center(child: Text('¡Guess It! conectado a Firebase con éxito.')),
      ),
    );
  }
}
