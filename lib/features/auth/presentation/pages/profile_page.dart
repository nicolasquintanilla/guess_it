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
  final Map<String, IconData> _availableAvatars = const <String, IconData>{
    'default': Icons.account_circle,
    'robot': Icons.smart_toy,
    'alien': Icons.adb,
    'ninja': Icons.visibility,
    'pet': Icons.pets,
    'rocket': Icons.rocket_launch,
    'gamepad': Icons.sports_esports,
    'diamond': Icons.diamond,
    'star': Icons.star,
    'fire': Icons.local_fire_department,
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
      helpText: 'Tu Tarjeta de Identificación de Guess It.\n\n'
          '🎨 Personalización:\n'
          'Toca tu icono actual en el centro de la pantalla para abrir el selector y elegir el avatar que mejor te represente. Usa el botón del lápiz para modificar tu nombre de usuario.\n\n'
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
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
                          ),
                          builder: (BuildContext ctx) {
                            return Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text('Elige tu Avatar', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                                  const SizedBox(height: 24),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                    ),
                                    itemCount: _availableAvatars.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final String key = _availableAvatars.keys.elementAt(index);
                                      final IconData icon = _availableAvatars[key]!;
                                      final bool isSelected = user.avatar == key;
                                      return GestureDetector(
                                        onTap: () {
                                          context.read<AuthBloc>().add(UpdateAvatarEvent(newAvatar: key));
                                          Navigator.pop(ctx);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isSelected ? Colors.deepPurple.withOpacity(0.2) : Colors.grey.shade100,
                                            shape: BoxShape.circle,
                                            border: isSelected ? Border.all(color: Colors.deepPurple, width: 3) : null,
                                          ),
                                          child: Icon(icon, size: 40, color: isSelected ? Colors.deepPurple : Colors.grey.shade700),
                                        ),
                                      );
                                    },
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
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                            child: Icon(
                              _availableAvatars[user.avatar] ?? Icons.account_circle,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.edit, color: Colors.deepPurple, size: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          user.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white70),
                          onPressed: () {
                            final TextEditingController nameController = TextEditingController(text: user.username);
                            showCupertinoDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return CupertinoAlertDialog(
                                  title: const Text('Cambiar Nombre'),
                                  content: Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: CupertinoTextField(
                                      controller: nameController,
                                      placeholder: 'Nuevo nombre',
                                      textCapitalization: TextCapitalization.words,
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
                                        final String newName = nameController.text.trim();
                                        if (newName.isNotEmpty && newName != user.username) {
                                          context.read<AuthBloc>().add(UpdateUsernameEvent(newUsername: newName));
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
                              : <Color>[Colors.blueGrey.shade400, Colors.blueGrey.shade700],
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
                        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
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
  })  : key = key,
        icon = icon,
        iconColor = iconColor,
        value = value,
        title = title;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 40,
              color: iconColor,
            ),
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
