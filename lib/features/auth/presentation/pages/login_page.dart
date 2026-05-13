import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_event.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_state.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';

class LoginPage extends StatefulWidget {
  @override
  final Key? key;

  const LoginPage({Key? key}) : key = key;

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
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
    } else if (error.contains('user-not-found')) {
      return 'No existe ningún usuario con este correo.';
    } else if (error.contains('invalid-credential') ||
        error.contains('wrong-password')) {
      return 'El correo o la contraseña no son correctos.';
    } else if (error.contains('email-already-in-use')) {
      return 'Este correo ya está registrado en otra cuenta.';
    } else if (error.contains('too-many-requests')) {
      return 'Demasiados intentos. Inténtalo más tarde.';
    } else if (error.contains('User data not found')) {
      return 'Este usuario no existe.';
    }
    return 'Error inesperado: $error';
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

  void _showResetPasswordDialog(BuildContext context) {
    final TextEditingController resetEmailController = TextEditingController();
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: const Text('Recuperar Contraseña'),
          content: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: CupertinoTextField(
              controller: resetEmailController,
              placeholder: 'Correo electrónico',
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Enviar'),
              onPressed: () {
                final String email = resetEmailController.text.trim();
                if (email.isNotEmpty) {
                  context.read<AuthBloc>().add(
                    ResetPasswordEvent(email: email),
                  );
                }
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      showBackArrow: false,
      child: BlocConsumer<AuthBloc, AuthState>(
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
          } else if (state.status == AuthStatus.passwordResetSent) {
            _showCupertinoAlert(
              context,
              'Éxito',
              'Correo enviado. Revisa tu bandeja de entrada',
            );
            context.read<AuthBloc>().add(const ResetAuthStatusEvent());
          }
        },
        builder: (BuildContext context, AuthState state) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
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
                              'Guess It!',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 32),
                            if (state.status == AuthStatus.loading)
                              const CircularProgressIndicator()
                            else ...<Widget>[
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: 'Correo electrónico',
                                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.deepPurple),
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
                                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.deepPurple),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                obscureText: true,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () =>
                                      _showResetPasswordDialog(context),
                                  child: const Text(
                                    '¿Olvidaste tu contraseña?',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  gradient: const LinearGradient(
                                    colors: <Color>[Colors.orangeAccent, Colors.pinkAccent],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent, 
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                                  ),
                                  onPressed: () {
                                    final String email = emailController.text.trim();
                                    final String password = passwordController.text.trim();

                                    if (email.isEmpty || password.isEmpty) {
                                      _showCupertinoAlert(
                                        context,
                                        'Datos Incompletos',
                                        'Por favor, introduce tu correo electrónico y contraseña.',
                                      );
                                      return;
                                    }

                                    context.read<AuthBloc>().add(
                                      LoginHostEvent(
                                        email: email,
                                        password: password,
                                      ),
                                    );
                                  },
                                  child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  context.push('/register');
                                },
                                child: const Text(
                                  '¿No tienes cuenta? Regístrate aquí',
                                  style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    context.read<AuthBloc>().add(
                                      const PlayAsGuestEvent(),
                                    );
                                  },
                                  icon: const Icon(Icons.no_accounts),
                                  label: const Text('Jugar como Invitado'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.deepPurpleAccent,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                                    side: BorderSide(
                                      color: Colors.deepPurpleAccent.withOpacity(0.5),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
