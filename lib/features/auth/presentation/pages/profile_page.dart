import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/features/auth/domain/entities/user_entity.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_event.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_state.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_bloc.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_event.dart';

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
  static const String _defaultSimpleAvatarKey =
      'none'; // Clave para la silueta simple

  final Map<String, String> _availableAvatars = const <String, String>{
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
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: 'Mi Perfil',
      helpText:
          'Tu Tarjeta de Identificación de Guess It.\n\n'
          '🎨 Personalización:\n'
          'Toca tu icono actual en el centro de la pantalla para abrir el selector y elegir el avatar que mejor te represente. La silueta simple es el avatar por defecto. Usa el botón del lápiz para modificar tu nombre de usuario.\n\n'
          '📊 Tus Estadísticas:\n'
          '• Victorias: Partidas en las que tu equipo quedó en primer lugar.\n'
          '• Partidas: El total de veces que has jugado.\n'
          '• Eficacia: Tu porcentaje de éxito (Victorias / Partidas).\n\n'
          '🚨 Eliminar Cuenta:\n'
          'Si usas el botón rojo inferior, todos tus datos, estadísticas y grupos se borrarán permanentemente de los servidores.',
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
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          isScrollControlled:
                              true, // ¡CRÍTICO PARA EL OVERFLOW!
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(32.0),
                            ),
                          ),
                          builder: (BuildContext ctx) {
                            return SizedBox(
                              height:
                                  MediaQuery.of(context).size.height *
                                  0.75, // Ocupa el 75% de la pantalla
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 24),
                                  const Text(
                                    'Elige tu Avatar',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    // Hace que el GridView ocupe el espacio sobrante y sea scrolleable
                                    child: SingleChildScrollView(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                        vertical: 8.0,
                                      ),
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                              crossAxisSpacing: 16,
                                              mainAxisSpacing: 16,
                                            ),
                                        itemCount: _availableAvatars.length + 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                              final String key = index == 0
                                                  ? _defaultSimpleAvatarKey
                                                  : _availableAvatars.keys
                                                        .elementAt(index - 1);
                                              final bool isSelected =
                                                  user.avatar == key;
                                              return GestureDetector(
                                                onTap: () {
                                                  context.read<AuthBloc>().add(
                                                    UpdateAvatarEvent(
                                                      newAvatar: key,
                                                    ),
                                                  );
                                                  Navigator.pop(ctx);
                                                },
                                                child: _renderAvatarImage(
                                                  avatarKey:
                                                      key, // 'simple' o 'arana'...
                                                  size:
                                                      60, // Ajusta el tamaño de la cuadrícula
                                                  isSelected: isSelected,
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          _renderAvatarImage(avatarKey: user.avatar, size: 100),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.deepPurple,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          width: 48,
                        ), // Espacio fantasma para equilibrar el icono
                        Expanded(
                          child: Text(
                            user.username,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white70),
                          onPressed: () {
                            final TextEditingController nameController =
                                TextEditingController(text: user.username);
                            showCupertinoDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return CupertinoAlertDialog(
                                  title: const Text('Cambiar Nombre'),
                                  content: Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: CupertinoTextField(
                                      controller: nameController,
                                      maxLength: 10,
                                      placeholder: 'Nuevo nombre',
                                      textCapitalization:
                                          TextCapitalization.words,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: const Text('Cancelar'),
                                      onPressed: () => Navigator.of(ctx).pop(),
                                    ),
                                    CupertinoDialogAction(
                                      child: const Text('Guardar'),
                                      onPressed: () {
                                        final String newName = nameController
                                            .text
                                            .trim();
                                        if (newName.isNotEmpty &&
                                            newName != user.username) {
                                          context.read<AuthBloc>().add(
                                            UpdateUsernameEvent(
                                              newUsername: newName,
                                            ),
                                          );
                                        }
                                        Navigator.of(ctx).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: _StatCard(
                            icon: Icons.emoji_events,
                            iconColor: Colors.amber,
                            value: user.victories.toString(),
                            title: 'Victorias',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.sports_esports,
                            iconColor: Colors.blueAccent,
                            value: user.gamesPlayed.toString(),
                            title: 'Partidas',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        gradient: LinearGradient(
                          colors: winRate >= 50
                              ? <Color>[Colors.orangeAccent, Colors.deepOrange]
                              : <Color>[
                                  Colors.blueGrey.shade400,
                                  Colors.blueGrey.shade700,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 32.0,
                          horizontal: 16.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.bolt,
                              size: 48,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${winRate.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Eficacia',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
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
                                '¿Estás seguro? Esta acción borrará todos tus datos y grupos de forma permanente',
                              ),
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
                                    context.read<GroupBloc>().add(
                                      const ClearGroupsEvent(),
                                    );
                                    context.read<AuthBloc>().add(
                                      const DeleteAccountEvent(),
                                    );
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

  Widget _renderAvatarImage({
    required String? avatarKey,
    required double size,
    bool isSelected = false,
  }) {
    // Lógica para el avatar predeterminado 'Simple'
    if (avatarKey == null ||
        avatarKey == _defaultSimpleAvatarKey ||
        !_availableAvatars.containsKey(avatarKey)) {
      return Container(
        width: size,
        height: size,
        decoration: null, // ¡Diseño Óptimo: 100% transparente para la silueta!
        child: Center(
          child: Icon(
            Icons.person_pin,
            size: size * 0.8,
            color: Colors.grey,
          ), // ¡Icono Gris!
        ),
      );
    }

    // Lógica para los 39 avatares PNG neón (Diseño Óptimo)
    final String imagePath = _availableAvatars[avatarKey]!;
    return Container(
      width: size,
      height: size,
      decoration: isSelected
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepPurple.withOpacity(0.2),
            ) // Glow de selección
          : null, // Sin fondo ni borde para que el neón destaque
      padding: const EdgeInsets.all(
        4.0,
      ), // Margen para que no se corten los bordes
      child: Image.asset(
        imagePath,
        fit: BoxFit
            .contain, // Muy importante para que no se corte y respete el PNG
        errorBuilder: (context, error, stackTrace) => Container(
          width: size,
          height: size,
          color: Colors.red.withOpacity(0.1),
          child: Icon(
            Icons.help_outline,
            color: Colors.white,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  @override
  final Key? key;
  final IconData icon;
  final Color iconColor;
  final String value;
  final String title;

  const _StatCard({
    Key? key,
    required IconData icon,
    required Color iconColor,
    required String value,
    required String title,
  }) : key = key,
       icon = icon,
       iconColor = iconColor,
       value = value,
       title = title;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
