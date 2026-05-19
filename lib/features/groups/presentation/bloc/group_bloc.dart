import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/groups/domain/repositories/group_repository.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_event.dart';
import 'package:guess_it/features/groups/presentation/bloc/group_state.dart';
import 'package:guess_it/features/groups/domain/entities/group_entity.dart';
import 'package:guess_it/core/utils/network_checker.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository repository;
  StreamSubscription<List<GroupEntity>>? _groupsSubscription;

  GroupBloc({required GroupRepository repository})
    : repository = repository,
      super(const GroupState()) {
    on<LoadGroupsEvent>(_onLoadGroups);
    on<GroupsUpdatedEvent>(_onGroupsUpdated);
    on<CreateGroupEvent>(_onCreateGroup);
    on<JoinGroupEvent>(_onJoinGroup);
    on<DeleteGroupEvent>(_onDeleteGroup);
    on<LeaveGroupEvent>(_onLeaveGroup);
    on<ClearGroupsEvent>(_onClearGroups);
    on<KickMemberEvent>(_onKickMember);
  }

  Future<void> _onLoadGroups(
    LoadGroupsEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(status: GroupStatus.loading));
    if (!await NetworkChecker.hasConnection()) {
      emit(state.copyWith(
        status: GroupStatus.error,
        errorMessage: 'No hay conexión a internet. Por favor, comprueba tu red.',
      ));
      return;
    }
    try {
      await _groupsSubscription?.cancel();
      _groupsSubscription = repository.getUserGroups().listen(
        (List<GroupEntity> groups) => add(GroupsUpdatedEvent(groups: groups)),
        onError: (Object e) =>
            add(GroupsUpdatedEvent(groups: const <GroupEntity>[])),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GroupStatus.error,
          errorMessage: e.toString(),
          groups: const <GroupEntity>[],
        ),
      );
    }
  }

  void _onGroupsUpdated(GroupsUpdatedEvent event, Emitter<GroupState> emit) {
    emit(state.copyWith(status: GroupStatus.success, groups: event.groups));
  }

  Future<void> _onCreateGroup(
    CreateGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(status: GroupStatus.loading));
    if (!await NetworkChecker.hasConnection()) {
      emit(state.copyWith(
        status: GroupStatus.error,
        errorMessage: 'No hay conexión a internet. Por favor, comprueba tu red.',
      ));
      return;
    }
    try {
      await repository.createGroup(event.groupName);
      add(const LoadGroupsEvent());
      emit(
        state.copyWith(
          status: GroupStatus.success,
          successMessage: '¡Grupo creado con éxito!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: GroupStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onJoinGroup(
    JoinGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(status: GroupStatus.loading));
    if (!await NetworkChecker.hasConnection()) {
      emit(state.copyWith(
        status: GroupStatus.error,
        errorMessage: 'No hay conexión a internet. Por favor, comprueba tu red.',
      ));
      return;
    }
    try {
      await repository.joinGroup(event.joinCode);
      add(const LoadGroupsEvent());
      emit(
        state.copyWith(
          status: GroupStatus.success,
          successMessage: '¡Te has unido al grupo!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: GroupStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onDeleteGroup(
    DeleteGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(status: GroupStatus.loading));
    if (!await NetworkChecker.hasConnection()) {
      emit(state.copyWith(
        status: GroupStatus.error,
        errorMessage: 'No hay conexión a internet. Por favor, comprueba tu red.',
      ));
      return;
    }
    try {
      await repository.deleteGroup(event.groupId);
      add(const LoadGroupsEvent());
      emit(
        state.copyWith(
          status: GroupStatus.success,
          successMessage: 'Grupo eliminado',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: GroupStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onLeaveGroup(
    LeaveGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(status: GroupStatus.loading));
    if (!await NetworkChecker.hasConnection()) {
      emit(state.copyWith(
        status: GroupStatus.error,
        errorMessage: 'No hay conexión a internet. Por favor, comprueba tu red.',
      ));
      return;
    }
    try {
      await repository.leaveGroup(event.groupId);
      add(const LoadGroupsEvent());
      emit(
        state.copyWith(
          status: GroupStatus.success,
          successMessage: 'Has salido del grupo',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: GroupStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void _onClearGroups(ClearGroupsEvent event, Emitter<GroupState> emit) {
    _groupsSubscription?.cancel();
    _groupsSubscription = null;
    emit(const GroupState());
  }

  Future<void> _onKickMember(
    KickMemberEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(status: GroupStatus.loading));
    if (!await NetworkChecker.hasConnection()) {
      emit(state.copyWith(
        status: GroupStatus.error,
        errorMessage: 'No hay conexión a internet. Por favor, comprueba tu red.',
      ));
      return;
    }
    try {
      await repository.kickMember(
        event.groupId,
        event.memberName,
        event.memberEmail,
      );
      add(const LoadGroupsEvent()); // Recargamos para ver la lista actualizada
      emit(
        state.copyWith(
          status: GroupStatus.success,
          successMessage: 'Miembro expulsado del grupo.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: GroupStatus.error, errorMessage: e.toString()),
      );
    }
  }

  @override
  Future<void> close() async {
    await _groupsSubscription?.cancel();
    return super.close();
  }
}
