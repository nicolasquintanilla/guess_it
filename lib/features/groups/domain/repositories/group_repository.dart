import '../entities/group_entity.dart';

/// Contrato del repositorio encargado de la gestión de grupos.
///
/// Define las operaciones CRUD y las interacciones de los usuarios con los
/// diferentes grupos, abstrayendo la implementación real (ej. Firebase Firestore).
abstract class GroupRepository {
  /// Crea un nuevo grupo donde el usuario actual será el anfitrión.
  ///
  /// @param groupName El nombre del grupo a crear.
  /// @return Un [Future] que se completa con el código de invitación (`joinCode`) generado.
  Future<String> createGroup(String groupName);

  /// Añade al usuario actual como miembro de un grupo existente mediante su código.
  ///
  /// @param joinCode El código de invitación de 6 caracteres.
  /// @return Un [Future] que se completa cuando la unión es exitosa.
  Future<void> joinGroup(String joinCode);

  /// Obtiene un flujo de datos (Stream) en tiempo real con todos los grupos a los
  /// que pertenece o administra el usuario actual.
  ///
  /// @return Un [Stream] que emite una lista de [GroupEntity] cada vez que hay cambios.
  Stream<List<GroupEntity>> getUserGroups();

  /// Elimina un grupo por completo. Solo debe ser llamado por el anfitrión.
  ///
  /// @param groupId El identificador del grupo a eliminar.
  /// @return Un [Future] que se completa cuando el grupo se elimina.
  Future<void> deleteGroup(String groupId);

  /// Elimina al usuario actual de la lista de miembros de un grupo.
  ///
  /// @param groupId El identificador del grupo a abandonar.
  /// @return Un [Future] que se completa tras abandonar el grupo exitosamente.
  Future<void> leaveGroup(String groupId);

  /// Expulsa a un miembro específico de un grupo. Solo debe ser llamado por el anfitrión.
  ///
  /// @param groupId El identificador del grupo.
  /// @param memberName El nombre del miembro a expulsar.
  /// @param memberEmail El correo electrónico del miembro a expulsar.
  /// @return Un [Future] que se completa al finalizar la expulsión.
  Future<void> kickMember(
    String groupId,
    String memberName,
    String memberEmail,
  );
}
