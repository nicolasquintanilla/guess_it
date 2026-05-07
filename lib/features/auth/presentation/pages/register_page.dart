import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_event.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  @override
  final Key? key;

  const RegisterPage({Key? key}) : key = key;

  @override
  State<RegisterPage> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String _translateError(String error) {
    if (error.contains('invalid-email')) {
      return 'El formato del correo no es válido.';
    } else if (error.contains('user-not-found') ||
        error.contains('invalid-credential')) {
      return 'Usuario o contraseña incorrectos.';
    } else if (error.contains('email-already-in-use')) {
      return 'Este correo ya está registrado.';
    }
    return 'Ha ocurrido un error de conexión.';
  }

  void _showCupertinoAlert(BuildContext context, String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Entendido'),
              onPressed: () {
                Navigator.of(ctx, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state.status == AuthStatus.error) {
            final String translatedMsg = _translateError(
              state.errorMessage ?? '',
            );
            _showCupertinoAlert(
              context,
              'Error de Autenticación',
              translatedMsg,
            );
          } else if (state.status == AuthStatus.authenticated) {
            context.go('/hub');
          }
        },
        builder: (BuildContext context, AuthState state) {
          return Stack(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Colors.deepPurple, Colors.deepPurpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: -50,
                child: Icon(
                  Icons.videogame_asset,
                  size: 250,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              Positioned(
                bottom: -50,
                right: -50,
                child: Icon(
                  Icons.extension,
                  size: 300,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      elevation: 8,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text(
                              'Nuevo Jugador',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 32),
                            if (state.status == AuthStatus.loading)
                              const CircularProgressIndicator()
                            else ...<Widget>[
                              TextField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                ),
                                obscureText: true,
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final String username = usernameController
                                        .text
                                        .trim();
                                    final String email = emailController.text
                                        .trim();
                                    final String password = passwordController
                                        .text
                                        .trim();

                                    if (username.isEmpty ||
                                        email.isEmpty ||
                                        password.isEmpty) {
                                      _showCupertinoAlert(
                                        context,
                                        'Datos Incompletos',
                                        'Por favor, rellena todos los campos para registrarte.',
                                      );
                                      return;
                                    }

                                    context.read<AuthBloc>().add(
                                      RegisterHostEvent(
                                        username: username,
                                        email: email,
                                        password: password,
                                      ),
                                    );
                                  },
                                  child: const Text('Registrarse'),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text(
                                  'Volver al Login',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
