import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/ranking/domain/entities/ranking_entity.dart';
import 'package:guess_it/features/ranking/domain/repositories/ranking_repository.dart';

// --- ESTADOS ---

abstract class RankingState extends Equatable {
  const RankingState();

  @override
  List<Object?> get props => <Object?>[];
}

class RankingInitial extends RankingState {
  const RankingInitial();
}

class RankingLoading extends RankingState {
  const RankingLoading();
}

class RankingLoaded extends RankingState {
  final List<RankingEntity> rankings;

  const RankingLoaded({
    required List<RankingEntity> rankings,
  }) : rankings = rankings;

  @override
  List<Object?> get props => <Object?>[rankings];
}

class RankingError extends RankingState {
  final String message;

  const RankingError({
    required String message,
  }) : message = message;

  @override
  List<Object?> get props => <Object?>[message];
}

// --- EVENTOS ---

abstract class RankingEvent extends Equatable {
  const RankingEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class SubmitWinEvent extends RankingEvent {
  final int points;

  const SubmitWinEvent({
    required int points,
  }) : points = points;

  @override
  List<Object?> get props => <Object?>[points];
}

class FetchRankingEvent extends RankingEvent {
  const FetchRankingEvent();
}

// --- BLOC ---

class RankingBloc extends Bloc<RankingEvent, RankingState> {
  final RankingRepository repository;

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
      await repository.addWinAndPoints(points: event.points);
    } catch (_) {
      // Al ser un guardado silencioso, se ignora el error de red
      // para no interrumpir el UI de celebración si hay un problema de conexión.
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
