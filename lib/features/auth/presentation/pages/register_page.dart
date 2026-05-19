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
  bool _obscurePassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String _translateError(String error) {
    if (error.contains('network-request-failed')) {
      return 'No hay conexión a Internet. Revisa tu red.';
    } else if (error.contains('weak-password')) {
      return 'La contraseña es muy débil. Usa al menos 6 caracteres.';
    } else if (error.contains('invalid-email')) {
      return 'El formato del correo no es válido.';
    } else if (error.contains('user-not-found') ||
        error.contains('invalid-credential') ||
        error.contains('wrong-password')) {
      return 'El correo o la contraseña son incorrectos.';
    } else if (error.contains('email-already-in-use')) {
      return 'Este correo ya está registrado en otra cuenta.';
    } else if (error.contains('too-many-requests')) {
      return 'Demasiados intentos. Inténtalo más tarde.';
    } else if (error.contains('permission-denied')) {
      return 'Error de permisos al crear la cuenta. Inténtalo de nuevo.';
    }

    if (error.isNotEmpty && !error.contains('[') && !error.contains('/')) {
      return error;
    }

    return 'Ha ocurrido un error inesperado. Por favor, inténtalo más tarde.';
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
        listenWhen: (AuthState previous, AuthState current) =>
            previous.status != current.status,
        listener: (BuildContext context, AuthState state) {
          if (!ModalRoute.of(context)!.isCurrent) return;

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
                                maxLength: 10,
                                decoration: InputDecoration(
                                  labelText: 'Nombre de usuario',
                                  prefixIcon: const Icon(
                                    Icons.person_outline,
                                    color: Colors.deepPurple,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: 'Correo electrónico',
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Colors.deepPurple,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Colors.deepPurple,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                obscureText: _obscurePassword,
                              ),
                              const SizedBox(height: 32),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  gradient: const LinearGradient(
                                    colors: <Color>[
                                      Colors.orangeAccent,
                                      Colors.pinkAccent,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                  ),
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
                                  child: const Text(
                                    'Registrarse',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text(
                                  '¿Ya tienes cuenta? Inicia sesión',
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
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
