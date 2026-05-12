import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_event.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_state.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';

class HubPage extends StatelessWidget {
  @override
  final Key? key;

  const HubPage({Key? key}) : key = key;

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: '', // El título lo pondremos en el encabezado personalizado
      showBackArrow: false,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          tooltip: 'Cerrar Sesión',
          onPressed: () {
            context.read<AuthBloc>().add(const LogoutEvent());
            context.go('/');
          },
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
          final bool isGuest = state.user?.isGuest ?? true;
          final String displayUsername = isGuest ? 'Invitado' : (state.user?.username ?? 'Invitado');

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // 1. Encabezado de Bienvenida
                  Row(
                    children: <Widget>[
                      const CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, size: 36, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              '¡Guess It!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Hola, $displayUsername',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // 2. Botón 'JUGAR' Destacado (C.T.A.)
                  GestureDetector(
                    onTap: () => context.push('/game-setup'),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: const LinearGradient(
                          colors: <Color>[Colors.orangeAccent, Colors.pinkAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.play_arrow_rounded,
                              size: 60,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text(
                                    'Empezar Partida',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 3. Grid 2x2 para el Resto
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: <Widget>[
                      _GridItem(
                        title: 'Mis Grupos',
                        description: 'Gestiona tus grupos',
                        icon: Icons.group,
                        iconColor: Colors.purple,
                        onTap: () => context.push('/groups'),
                      ),
                      _GridItem(
                        title: 'Ranking Global',
                        description: 'Los mejores del mundo',
                        icon: Icons.leaderboard,
                        iconColor: Colors.blue,
                        onTap: () => context.push('/ranking'),
                      ),
                      _GridItem(
                        title: 'Cómo Jugar',
                        description: 'Reglas de Juego',
                        icon: Icons.menu_book,
                        iconColor: Colors.green,
                        onTap: () => context.push('/how-to-play'),
                      ),
                      _GridItem(
                        title: 'Mi Cuenta',
                        description: 'Estadísticas y perfil',
                        icon: Icons.person,
                        iconColor: Colors.orange,
                        onTap: () => context.push('/profile'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  final Key? key;

  const _GridItem({
    Key? key,
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  })  : key = key,
        title = title,
        description = description,
        icon = icon,
        iconColor = iconColor,
        onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
