import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_event.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_state.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_bloc.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_event.dart';

class HubPage extends StatefulWidget {
  @override
  final Key? key;

  const HubPage({Key? key}) : key = key;

  @override
  State<HubPage> createState() {
    return _HubPageState();
  }
}

class _HubPageState extends State<HubPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const ReloadUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: '', // El título lo pondremos en el encabezado personalizado
      showBackArrow: false,
      helpText:
          '¡Te damos la bienvenida al centro de mando de Guess It!\n\n'
          'Desde aquí puedes acceder a todas las funciones del juego:\n\n'
          '🎮 Empezar Partida: Configura los equipos, elige cuántas palabras queréis adivinar y lánzate a jugar.\n\n'
          '👥 Mis Grupos: Crea grupos cerrados con tus amigos. Cada vez que juguéis usando un grupo, se generará una clasificación interna para ver quién es el mejor de la pandilla.\n\n'
          '🌍 Ranking Global: Compite contra jugadores de todo el mundo. Las victorias que consigas en tus partidas se sumarán aquí.\n\n'
          '📖 Cómo Jugar: Repasa las reglas de las tres rondas del juego para que nadie haga trampas.\n\n'
          '👤 Mi Cuenta: Personaliza tu nombre, cambia tu avatar y revisa tu eficacia de victorias.',
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          tooltip: 'Cerrar Sesión',
          onPressed: () {
            context.read<GroupBloc>().add(const ClearGroupsEvent());
            context.read<AuthBloc>().add(const LogoutEvent());
            context.go('/');
          },
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
          final Map<String, String> availableAvatars = const <String, String>{
            'arana': 'assets/avatars/arana.png',
            'astronauta': 'assets/avatars/astronauta.png',
            'auto-de-choque': 'assets/avatars/auto-de-choque.png',
            'buho': 'assets/avatars/buho.png',
            'cangrejo': 'assets/avatars/cangrejo.png',
            'casco-romano': 'assets/avatars/casco-romano.png',
            'cerdo': 'assets/avatars/cerdo.png',
            'cerezas': 'assets/avatars/cerezas.png',
            'chile': 'assets/avatars/chile.png',
            'coche-rc': 'assets/avatars/coche-rc.png',
            'cohete': 'assets/avatars/cohete.png',
            'craneo': 'assets/avatars/craneo.png',
            'dinosaurio': 'assets/avatars/dinosaurio.png',
            'elefante': 'assets/avatars/elefante.png',
            'extraterrestre': 'assets/avatars/extraterrestre.png',
            'flecha': 'assets/avatars/flecha.png',
            'futbol': 'assets/avatars/futbol.png',
            'gato': 'assets/avatars/gato.png',
            'gorila': 'assets/avatars/gorila.png',
            'hueso': 'assets/avatars/hueso.png',
            'juego-de-azar': 'assets/avatars/juego-de-azar.png',
            'leon': 'assets/avatars/leon.png',
            'momia': 'assets/avatars/momia.png',
            'ninja': 'assets/avatars/ninja.png',
            'ojo': 'assets/avatars/ojo.png',
            'ornitorrinco': 'assets/avatars/ornitorrinco.png',
            'oveja': 'assets/avatars/oveja.png',
            'pistola-de-agua': 'assets/avatars/pistola-de-agua.png',
            'pollo': 'assets/avatars/pollo.png',
            'robot': 'assets/avatars/robot.png',
            'rosquilla': 'assets/avatars/rosquilla.png',
            'saturno': 'assets/avatars/saturno.png',
            'serpiente': 'assets/avatars/serpiente.png',
            'shuriken': 'assets/avatars/shuriken.png',
            'soldado': 'assets/avatars/soldado.png',
            'tallarines': 'assets/avatars/tallarines.png',
            'tortuga': 'assets/avatars/tortuga.png',
            'trofeo': 'assets/avatars/trofeo.png',
            'vaso': 'assets/avatars/vaso.png',
          };
          final bool isGuest = state.user?.isGuest ?? true;
          final String displayUsername = isGuest
              ? 'Invitado'
              : (state.user?.username ?? 'Invitado');

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // 1. Encabezado de Bienvenida
                  Row(
                    children: <Widget>[
                      Builder(
                        builder: (context) {
                          final String avatarKey = state.user?.avatar ?? 'none';
                          final bool isSimple = avatarKey == 'none' || !availableAvatars.containsKey(avatarKey);
                          final double avatarSize = 64;
                          
                          final Widget avatarWidget = isSimple
                              ? Icon(Icons.person_pin, color: Colors.grey, size: avatarSize * 0.8)
                              : Image.asset(availableAvatars[avatarKey]!, fit: BoxFit.contain);

                          return Container(
                            width: avatarSize,
                            height: avatarSize,
                            decoration: null, // Transparente 100%
                            child: Center(child: avatarWidget),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              displayUsername,
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
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0,
                        ),
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
                    childAspectRatio: 0.75,
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
  }) : key = key,
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
              const SizedBox(height: 8),
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
