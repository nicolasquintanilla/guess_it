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
import 'package:guess_it/features/profile/presentation/widgets/guest_profile_view.dart';
import 'package:guess_it/features/profile/presentation/widgets/avatar_renderer.dart';
import 'package:guess_it/features/profile/presentation/widgets/stat_card.dart';
import 'package:guess_it/features/profile/presentation/widgets/efficacy_card.dart';

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
            return const GuestProfileView();
          }

          final double winRate = user.gamesPlayed == 0
              ? 0
              : (user.victories / user.gamesPlayed) * 100;

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 24.0,
              ),
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
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(32.0),
                            ),
                          ),
                          builder: (BuildContext ctx) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.75,
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
                                    child: SingleChildScrollView(
                                      padding: EdgeInsets.only(
                                        left: 24.0,
                                        right: 24.0,
                                        top: 8.0,
                                        bottom:
                                            MediaQuery.of(
                                              context,
                                            ).padding.bottom +
                                            24.0,
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
                                                child: AvatarRenderer(
                                                  avatarKey: key,
                                                  size: 60,
                                                  isSelected: isSelected,
                                                  availableAvatars:
                                                      _availableAvatars,
                                                  defaultSimpleAvatarKey:
                                                      _defaultSimpleAvatarKey,
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
                          AvatarRenderer(
                            avatarKey: user.avatar,
                            size: 100,
                            availableAvatars: _availableAvatars,
                            defaultSimpleAvatarKey: _defaultSimpleAvatarKey,
                          ),
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
                        const SizedBox(width: 48),
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
                          child: StatCard(
                            icon: Icons.emoji_events,
                            iconColor: Colors.amber,
                            value: user.victories.toString(),
                            title: 'Victorias',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatCard(
                            icon: Icons.sports_esports,
                            iconColor: Colors.blueAccent,
                            value: user.gamesPlayed.toString(),
                            title: 'Partidas',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    EfficacyCard(winRate: winRate),
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
}
