import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/features/auth/domain/entities/user_entity.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_event.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_state.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';

class ProfilePage extends StatefulWidget {
  @override
  final Key? key;

  const ProfilePage({Key? key}) : key = key;

  @override
  State<ProfilePage> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const ReloadUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: 'Mi Perfil',
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state.status == AuthStatus.initial) {
            context.go('/');
          }
        },
        builder: (BuildContext context, AuthState state) {
          final UserEntity? user = state.user;

          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (user.isGuest) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.no_accounts,
                      size: 150,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Los invitados no guardan estadísticas. ¡Regístrate para competir!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final double winRate = user.gamesPlayed == 0
              ? 0
              : (user.victories / user.gamesPlayed) * 100;

          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.account_circle,
                      size: 120,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      elevation: 8,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 32.0,
                          horizontal: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            _StatItem(
                              title: 'Partidas',
                              value: user.gamesPlayed.toString(),
                            ),
                            _StatItem(
                              title: 'Victorias',
                              value: user.victories.toString(),
                            ),
                            _StatItem(
                              title: 'Tasa de Victorias',
                              value: '${winRate.toStringAsFixed(1)}%',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return CupertinoAlertDialog(
                              title: const Text('Eliminar cuenta'),
                              content: const Text(
                                  '¿Estás seguro? Esta acción borrará todos tus datos y grupos de forma permanente'),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: const Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                                CupertinoDialogAction(
                                  isDestructiveAction: true,
                                  child: const Text('Eliminar'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    context.read<AuthBloc>().add(const DeleteAccountEvent());
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Eliminar mi cuenta'),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
