import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_event.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_state.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_bloc.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_event.dart';
import 'package:guess_it/features/hub/presentation/widgets/hub_grid_item.dart';
import 'package:guess_it/features/hub/presentation/widgets/start_game_button.dart';
import 'package:guess_it/features/hub/presentation/widgets/user_header.dart';

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
  static const Map<String, String> _availableAvatars = <String, String>{
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

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const ReloadUserEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final AuthState authState = context.read<AuthBloc>().state;
    final String? avatarKey = authState.user?.avatar;
    if (avatarKey != null &&
        avatarKey != 'none' &&
        _availableAvatars.containsKey(avatarKey)) {
      precacheImage(AssetImage(_availableAvatars[avatarKey]!), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: '',
      showBackArrow: false,
      helpText:
          '¡Te damos la bienvenida al centro de mando de Guess It!\n\n'
          'Desde aquí puedes acceder a todas las funciones del juego:\n\n'
          '🎮 Empezar Partida: Configura los equipos, elige cuántas palabras queréis adivinar y lánzate a jugar.\n\n'
          '👥 Mis Grupos: Crea grupos cerrados con tus amigos. Cada vez que juguéis usando un grupo, se generará una clasificación interna para ver quién es el mejor del grupo.\n\n'
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
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  UserHeader(
                    authState: state,
                    availableAvatars: _availableAvatars,
                  ),
                  const SizedBox(height: 48),
                  StartGameButton(
                    onStart: () => context.push('/game-setup'),
                  ),
                  const SizedBox(height: 32),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                    children: <Widget>[
                      HubGridItem(
                        title: 'Mis Grupos',
                        description: 'Gestiona tus grupos',
                        icon: Icons.group,
                        iconColor: Colors.purple,
                        onTap: () => context.push('/groups'),
                      ),
                      HubGridItem(
                        title: 'Ranking Global',
                        description: 'Los mejores del mundo',
                        icon: Icons.leaderboard,
                        iconColor: Colors.blue,
                        onTap: () => context.push('/ranking'),
                      ),
                      HubGridItem(
                        title: 'Cómo Jugar',
                        description: 'Reglas de Juego',
                        icon: Icons.menu_book,
                        iconColor: Colors.green,
                        onTap: () => context.push('/how-to-play'),
                      ),
                      HubGridItem(
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
