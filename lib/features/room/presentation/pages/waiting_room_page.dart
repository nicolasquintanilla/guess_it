import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/room/presentation/bloc/room_bloc.dart';
import 'package:guess_it/features/room/presentation/bloc/room_state.dart';

class WaitingRoomPage extends StatelessWidget {
  const WaitingRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sala de Espera'),
      ),
      body: BlocBuilder<RoomBloc, RoomState>(
        builder: (BuildContext context, RoomState state) {
          if (state.status == RoomStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == RoomStatus.success && state.room != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Código de la sala:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.room!.roomId,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 8,
                    ),
                  ),
                ],
              ),
            );
          } else if (state.status == RoomStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'Error desconocido'));
          } else {
            return const Center(child: Text('Iniciando sala...'));
          }
        },
      ),
    );
  }
}
