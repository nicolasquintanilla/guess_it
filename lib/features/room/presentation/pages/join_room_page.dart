import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:guess_it/features/auth/presentation/bloc/auth_state.dart';
import 'package:guess_it/features/room/presentation/bloc/room_bloc.dart';
import 'package:guess_it/features/room/presentation/bloc/room_event.dart';
import 'package:guess_it/features/room/presentation/bloc/room_state.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';
import 'package:guess_it/features/room/presentation/widgets/room_code_input.dart';
import 'package:guess_it/features/room/presentation/widgets/join_room_button.dart';

/// Pantalla de interfaz gráfica para que un jugador invitado introduzca
/// el código y se una a una sala existente.
///
/// Gestiona la entrada de texto y escucha los cambios en el estado del [RoomBloc]
/// para navegar a la sala de espera en caso de éxito o mostrar un error.
class JoinRoomPage extends StatefulWidget {
  /// Crea una instancia de [JoinRoomPage].
  ///
  /// @param key El identificador opcional para el widget.
  const JoinRoomPage({Key? key}) : super(key: key);

  /// Crea el estado mutable necesario para esta pantalla.
  ///
  /// @return Una instancia de [_JoinRoomPageState].
  @override
  State<JoinRoomPage> createState() {
    return _JoinRoomPageState();
  }
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  final TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: 'Unirse a Partida',
      showBackArrow: true,
      child: BlocConsumer<RoomBloc, RoomState>(
        listener: (BuildContext context, RoomState state) {
          if (state.status == RoomStatus.success) {
            context.push('/waiting-room');
          } else if (state.status == RoomStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Error desconocido'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (BuildContext context, RoomState state) {
          if (state.status == RoomStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Introduce el código de la sala:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                RoomCodeInput(controller: codeController),
                const SizedBox(height: 32),
                JoinRoomButton(
                  onPressed: () {
                    final String roomId = codeController.text.trim();
                    if (roomId.isEmpty) {
                      return;
                    }
                    final AuthState authState = context.read<AuthBloc>().state;
                    if (authState.user != null) {
                      context.read<RoomBloc>().add(
                            JoinRoomEvent(
                              roomId: roomId,
                              guestId: authState.user!.id,
                            ),
                          );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
