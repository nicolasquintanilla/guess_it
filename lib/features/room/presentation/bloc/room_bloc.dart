import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/room/presentation/bloc/room_event.dart';
import 'package:guess_it/features/room/presentation/bloc/room_state.dart';
import 'package:guess_it/features/room/domain/usecases/create_room_usecase.dart';
import 'package:guess_it/features/room/domain/usecases/join_room_usecase.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final CreateRoomUseCase createRoomUseCase;
  final JoinRoomUseCase joinRoomUseCase;

  RoomBloc({
    required CreateRoomUseCase createRoomUseCase,
    required JoinRoomUseCase joinRoomUseCase,
  })  : createRoomUseCase = createRoomUseCase,
        joinRoomUseCase = joinRoomUseCase,
        super(RoomState.initial()) {
    on<CreateRoomEvent>(_onCreateRoom);
    on<JoinRoomEvent>(_onJoinRoom);
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

  Future<void> _onJoinRoom(
    JoinRoomEvent event,
    Emitter<RoomState> emit,
  ) async {
    emit(state.copyWith(status: RoomStatus.loading, errorMessage: null));
    final result = await joinRoomUseCase(
      roomId: event.roomId,
      guestId: event.guestId,
    );
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
