import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/room/presentation/bloc/room_event.dart';
import 'package:guess_it/features/room/presentation/bloc/room_state.dart';
import 'package:guess_it/features/room/domain/usecases/create_room_usecase.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final CreateRoomUseCase createRoomUseCase;

  RoomBloc({
    required CreateRoomUseCase createRoomUseCase,
  })  : createRoomUseCase = createRoomUseCase,
        super(RoomState.initial()) {
    on<CreateRoomEvent>(_onCreateRoom);
  }

  Future<void> _onCreateRoom(
    CreateRoomEvent event,
    Emitter<RoomState> emit,
  ) async {
    emit(state.copyWith(status: RoomStatus.loading, errorMessage: null));
    final result = await createRoomUseCase(event.hostId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: RoomStatus.error,
        errorMessage: failure.message,
      )),
      (room) => emit(state.copyWith(
        status: RoomStatus.success,
        room: room,
      )),
    );
  }
}
