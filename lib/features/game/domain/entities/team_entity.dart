import 'package:equatable/equatable.dart';

/// Representa a un equipo participante dentro de una partida.
///
/// Contiene el nombre del equipo, su puntuación acumulada, y la lista de
/// correos electrónicos de los jugadores que lo componen.
class TeamEntity extends Equatable {
  /// Nombre asignado al equipo (ej. "Equipo 1").
  final String name;

  /// Puntuación actual del equipo en la partida.
  final int score;

  /// Lista de correos electrónicos correspondientes a los integrantes del equipo.
  final List<String> registeredEmails;

  /// Crea una instancia de [TeamEntity].
  ///
  /// @param name El nombre del equipo.
  /// @param score La puntuación inicial (generalmente 0).
  /// @param registeredEmails La lista de correos de los miembros.
  const TeamEntity({
    required String name,
    required int score,
    List<String> registeredEmails = const <String>[],
  })  : name = name,
        score = score,
        registeredEmails = registeredEmails;

  /// Crea una copia de este equipo modificando únicamente los campos proporcionados.
  ///
  /// @param name Nuevo nombre para el equipo (opcional).
  /// @param score Nueva puntuación para el equipo (opcional).
  /// @param registeredEmails Nueva lista de correos (opcional).
  /// @return Una nueva instancia de [TeamEntity] con los datos actualizados.
  TeamEntity copyWith({
    String? name,
    int? score,
    List<String>? registeredEmails,
  }) {
    return TeamEntity(
      name: name ?? this.name,
      score: score ?? this.score,
      registeredEmails: registeredEmails ?? this.registeredEmails,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        name,
        score,
        registeredEmails,
      ];
}
