import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/room/presentation/bloc/room_bloc.dart';
import 'package:guess_it/features/room/presentation/bloc/room_state.dart';

import 'package:guess_it/core/widgets/premium_scaffold.dart';
import 'package:guess_it/features/room/presentation/widgets/room_code_display.dart';

class WaitingRoomPage extends StatelessWidget {
  const WaitingRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: 'Sala de Espera',
      showBackArrow: true,
      child: BlocBuilder<RoomBloc, RoomState>(
        builder: (BuildContext context, RoomState state) {
          if (state.status == RoomStatus.loading) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (state.status == RoomStatus.success && state.room != null) {
            return RoomCodeDisplay(roomId: state.room!.roomId);
          } else if (state.status == RoomStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Error desconocido',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Iniciando sala...',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }
}
