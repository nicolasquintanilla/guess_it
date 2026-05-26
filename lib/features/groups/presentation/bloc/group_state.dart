import 'package:equatable/equatable.dart';
import 'package:guess_it/features/groups/domain/entities/group_entity.dart';

enum GroupStatus { initial, loading, success, error }

/// Representa el estado actual de la pantalla y la gestión de grupos.
///
/// Mantiene la lista en memoria de los grupos del usuario y el estado
/// de las diferentes acciones asíncronas (carga, creación, unión).
class GroupState extends Equatable {
  /// Estado general del BLoC (inicial, cargando, éxito o error).
  final GroupStatus status;

  /// Mensaje de error para mostrar al usuario, si [status] es error.
  final String? errorMessage;

  /// Mensaje de éxito para mostrar notificaciones (ej. "Grupo creado").
  final String? successMessage;

  /// Lista actual de grupos a los que pertenece el usuario.
  final List<GroupEntity> groups;

  /// Crea una instancia de [GroupState].
  ///
  /// @param status El estado actual del flujo.
  /// @param errorMessage El mensaje en caso de error.
  /// @param successMessage El mensaje en caso de éxito en una acción.
  /// @param groups La lista de grupos del usuario.
  const GroupState({
    GroupStatus status = GroupStatus.initial,
    String? errorMessage,
    String? successMessage,
    List<GroupEntity> groups = const <GroupEntity>[],
  })  : status = status,
        errorMessage = errorMessage,
        successMessage = successMessage,
        groups = groups;

  /// Crea una copia de este estado modificando únicamente los campos proporcionados.
  ///
  /// @param status Nuevo estado general (opcional).
  /// @param errorMessage Nuevo mensaje de error (opcional).
  /// @param successMessage Nuevo mensaje de éxito (opcional).
  /// @param groups Nueva lista de grupos (opcional).
  /// @return Una nueva instancia de [GroupState] con los datos actualizados.
  GroupState copyWith({
    GroupStatus? status,
    String? errorMessage,
    String? successMessage,
    List<GroupEntity>? groups,
  }) {
    return GroupState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      groups: groups ?? this.groups,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, errorMessage, successMessage, groups];
}
