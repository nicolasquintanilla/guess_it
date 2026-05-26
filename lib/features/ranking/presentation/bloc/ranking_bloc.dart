import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/ranking/domain/entities/ranking_entity.dart';
import 'package:guess_it/features/ranking/domain/repositories/ranking_repository.dart';

// --- ESTADOS ---

/// Clase base para todos los estados relacionados con el ranking.
abstract class RankingState extends Equatable {
  /// Constructor base.
  const RankingState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Estado inicial del ranking antes de cualquier carga.
class RankingInitial extends RankingState {
  /// Constructor base.
  const RankingInitial();
}

/// Estado emitido mientras se descargan los datos del ranking.
class RankingLoading extends RankingState {
  /// Constructor base.
  const RankingLoading();
}

/// Estado emitido cuando la clasificación se ha cargado exitosamente.
class RankingLoaded extends RankingState {
  /// Lista ordenada con los mejores jugadores.
  final List<RankingEntity> rankings;

  /// Crea el estado con los datos recuperados.
  const RankingLoaded({
    required List<RankingEntity> rankings,
  }) : rankings = rankings;

  @override
  List<Object?> get props => <Object?>[rankings];
}

/// Estado emitido en caso de error durante la carga.
class RankingError extends RankingState {
  /// Mensaje descriptivo del error.
  final String message;

  /// Crea el estado con el mensaje indicado.
  const RankingError({
    required String message,
  }) : message = message;

  @override
  List<Object?> get props => <Object?>[message];
}

// --- EVENTOS ---

/// Clase base para todos los eventos del [RankingBloc].
abstract class RankingEvent extends Equatable {
  /// Constructor base.
  const RankingEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Evento para registrar las estadísticas finales de un usuario tras una partida.
class SubmitWinEvent extends RankingEvent {
  /// Total de puntos conseguidos en el juego.
  final int points;

  /// `true` si el equipo del usuario resultó ganador.
  final bool isVictory;

  /// Crea el evento con las métricas finales.
  const SubmitWinEvent({
    required int points,
    required bool isVictory,
  })  : points = points,
        isVictory = isVictory;

  @override
  List<Object?> get props => <Object?>[points, isVictory];
}

/// Evento que solicita la descarga de la clasificación global.
class FetchRankingEvent extends RankingEvent {
  /// Constructor base.
  const FetchRankingEvent();
}

// --- BLOC ---

/// BLoC encargado de manejar la lógica y estado del ranking.
///
/// Permite enviar resultados de nuevas partidas y consultar la lista
/// ordenada de los mejores jugadores.
class RankingBloc extends Bloc<RankingEvent, RankingState> {
  /// Repositorio inyectado para abstraer el acceso a datos.
  final RankingRepository repository;

  /// Crea una instancia de [RankingBloc].
  ///
  /// @param repository Implementación del repositorio de ranking.
  RankingBloc({
    required RankingRepository repository,
  })  : repository = repository,
        super(const RankingInitial()) {
    on<SubmitWinEvent>(_onSubmitWin);
    on<FetchRankingEvent>(_onFetchRanking);
  }

  Future<void> _onSubmitWin(
    SubmitWinEvent event,
    Emitter<RankingState> emit,
  ) async {
    try {
      await repository.addWinAndPoints(
        points: event.points,
        isVictory: event.isVictory,
      );
    } catch (_) {
    }
  }

  Future<void> _onFetchRanking(
    FetchRankingEvent event,
    Emitter<RankingState> emit,
  ) async {
    emit(const RankingLoading());
    try {
      final List<RankingEntity> rankings = await repository.getGlobalRanking();
      emit(RankingLoaded(rankings: rankings));
    } catch (e) {
      emit(RankingError(message: 'Error al cargar el ranking: $e'));
    }
  }
}
