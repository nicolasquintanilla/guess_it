import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/game/presentation/bloc/game_event.dart';
import 'package:guess_it/features/game/presentation/bloc/game_state.dart';
import 'package:guess_it/features/game/domain/entities/game_entity.dart';
import 'package:guess_it/features/game/domain/entities/team_entity.dart';
import 'package:guess_it/features/game/domain/repositories/word_repository.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final WordRepository wordRepository;
  Timer? _turnTimer;

  GameBloc({required WordRepository wordRepository})
    : wordRepository = wordRepository,
      super(GameState.initial()) {
    on<InitializeGameEvent>(_onInitializeGame);
    on<AddPointsEvent>(_onAddPoints);
    on<SwitchTurnEvent>(_onSwitchTurn);
    on<EndGameEvent>(_onEndGame);
    on<StartTurnEvent>(_onStartTurn);
    on<TickTimerEvent>(_onTickTimer);
    on<CorrectAnswerEvent>(_onCorrectAnswer);
    on<SkipWordEvent>(_onSkipWord);
    on<PauseGameEvent>(_onPauseGame);
    on<ResumeGameEvent>(_onResumeGame);
    on<TimeUpEvent>(_onTimeUp);
    on<ToggleWordReviewEvent>(_onToggleWordReview);
    on<ResetGameEvent>(_onResetGame);
    on<ProcessAiTurnEvent>(_onProcessAiTurn);
  }

  @override
  Future<void> close() {
    _turnTimer?.cancel();
    return super.close();
  }

  Future<void> _onInitializeGame(
    InitializeGameEvent event,
    Emitter<GameState> emit,
  ) async {
    emit(state.copyWith(status: GameStatus.loading));

    final List<String> generatedBag = await wordRepository.generateWordBag(
      event.userWords,
      event.targetWordCount,
    );

    final GameEntity newGame = GameEntity(
      teams: event.initialTeams,
      currentRound: 1,
      activeTeamIndex: 0,
      gameStatus: 'in_progress',
      hostTeamName: event.hostTeamName,
      turnDurationSeconds: event.turnDurationSeconds,
      groupId: event.groupId,
    );

    emit(
      state.copyWith(
        status: GameStatus.playing,
        game: newGame,
        remainingSeconds: 0,
        currentWord: '',
        currentBag: List<String>.from(generatedBag),
        masterBag: List<String>.from(generatedBag),
        turnGuessedWords: <String>[],
        turnSkippedWords: <String>[],
      ),
    );
  }

  void _onAddPoints(AddPointsEvent event, Emitter<GameState> emit) {
    if (state.game == null) {
      return;
    }

    final GameEntity currentGame = state.game!;

    final List<TeamEntity> updatedTeams = currentGame.teams.asMap().entries.map(
      (MapEntry<int, TeamEntity> entry) {
        if (entry.key == currentGame.activeTeamIndex) {
          return entry.value.copyWith(score: entry.value.score + event.points);
        }
        return entry.value;
      },
    ).toList();

    final GameEntity updatedGame = currentGame.copyWith(teams: updatedTeams);

    emit(state.copyWith(game: updatedGame));
  }

  Future<void> _onSwitchTurn(
    SwitchTurnEvent event,
    Emitter<GameState> emit,
  ) async {
    _turnTimer?.cancel();

    if (state.game == null) {
      return;
    }

    final GameEntity currentGame = state.game!;

    // 1. Sumar los puntos obtenidos en la revisión
    final int pointsEarned = state.turnGuessedWords.length;

    final List<TeamEntity> updatedTeams = currentGame.teams.asMap().entries.map(
      (MapEntry<int, TeamEntity> entry) {
        if (entry.key == currentGame.activeTeamIndex) {
          return entry.value.copyWith(score: entry.value.score + pointsEarned);
        }
        return entry.value;
      },
    ).toList();

    // 2. Reconstruir la bolsa con las palabras saltadas y la palabra a medias
    final List<String> newBag = List<String>.from(state.currentBag);
    newBag.addAll(state.turnSkippedWords);
    if (state.currentWord.isNotEmpty) {
      newBag.add(state.currentWord);
    }
    newBag.shuffle();

    GameEntity updatedGame = currentGame.copyWith(teams: updatedTeams);

    // 3. Comprobar si la bolsa resultante está vacía (Fin de Ronda)
    if (newBag.isEmpty) {
      if (updatedGame.currentRound < 3) {
        // Avanzar de ronda
        updatedGame = updatedGame.copyWith(
          currentRound: updatedGame.currentRound + 1,
        );
        newBag.addAll(state.masterBag);
        newBag.shuffle();

        // REGLA DEL PERDEDOR: Empieza el equipo con menos puntos
        int minScore = updatedGame.teams[0].score;
        int loserIndex = 0;
        for (int i = 1; i < updatedGame.teams.length; i++) {
          if (updatedGame.teams[i].score < minScore) {
            minScore = updatedGame.teams[i].score;
            loserIndex = i;
          }
        }
        updatedGame = updatedGame.copyWith(activeTeamIndex: loserIndex);

        emit(
          state.copyWith(
            status: GameStatus.playing,
            game: updatedGame,
            remainingSeconds: 0,
            currentWord: '',
            currentBag: newBag,
            turnGuessedWords: <String>[],
            turnSkippedWords: <String>[],
          ),
        );
      } else {
        // Fin del juego
        updatedGame = updatedGame.copyWith(gameStatus: 'finished');

        try {
          final FirebaseFirestore firestore = FirebaseFirestore.instance;
          int maxScore = -1;
          for (final TeamEntity team in updatedGame.teams) {
            if (team.score > maxScore) maxScore = team.score;
          }

        // --- LÓGICA ANTI-TRAMPAS RANKING GLOBAL ---
        final bool isAiGame = updatedGame.teams.any((TeamEntity t) => t.name.startsWith('IA Guess It'));
        
        int totalRegisteredEmails = 0;
        for (final TeamEntity team in updatedGame.teams) {
          // Contamos solo correos que tengan formato real
          totalRegisteredEmails += team.registeredEmails.where((String e) => e.contains('@')).length;
        }
        
        // REGLA DE ORO: Solo si hay 2+ humanos registrados, no hay IA, y hay puntos.
        if (!isAiGame && totalRegisteredEmails >= 2 && maxScore > 0) {
          for (final TeamEntity team in updatedGame.teams) {
            final bool isWinner = team.score == maxScore;
            for (final String emailOrName in team.registeredEmails) {
              final String cleanEmail = emailOrName.trim().toLowerCase();
              if (!cleanEmail.contains('@')) continue; 

              final QuerySnapshot<Map<String, dynamic>> userQuery =
                  await firestore.collection('users').where('email', isEqualTo: cleanEmail).limit(1).get();

              if (userQuery.docs.isNotEmpty) {
                final DocumentReference<Map<String, dynamic>> userRef = userQuery.docs.first.reference;
                await userRef.update(<String, dynamic>{
                  'gamesPlayed': FieldValue.increment(1),
                  'totalPointsScored': FieldValue.increment(team.score),
                  if (isWinner) 'victories': FieldValue.increment(1),
                });
              }
            }
          }
        }

          // --- LÓGICA DE RANKING DE GRUPO ---
          if (updatedGame.groupId != null && updatedGame.groupId!.isNotEmpty) {
            final DocumentReference<Map<String, dynamic>> groupRef = firestore.collection('groups').doc(updatedGame.groupId);
            final DocumentSnapshot<Map<String, dynamic>> groupDoc = await groupRef.get();
            
            if (groupDoc.exists) {
              final Map<String, dynamic> data = groupDoc.data()!;
              Map<String, int> groupScores = <String, int>{};
              
              // Extraer el mapa de puntuaciones si existe, forzando los tipos correctos
              if (data.containsKey('scores') && data['scores'] is Map) {
                final Map<dynamic, dynamic> rawScores = data['scores'] as Map<dynamic, dynamic>;
                rawScores.forEach((dynamic key, dynamic value) {
                  if (key is String && value is num) {
                    groupScores[key] = value.toInt();
                  }
                });
              }

              // Repartir puntos a los miembros que jugaron esta partida
              for (final TeamEntity team in updatedGame.teams) {
                final bool isWinner = team.score == maxScore && maxScore > 0;
                final int pointsToAssign = isWinner ? 3 : 1;

                for (final String email in team.registeredEmails) {
                  final String cleanEmail = email.trim().toLowerCase();
                  if (cleanEmail.isEmpty) continue;

                  final QuerySnapshot<Map<String, dynamic>> userQuery = await firestore
                      .collection('users')
                      .where('email', isEqualTo: cleanEmail)
                      .limit(1)
                      .get();

                  if (userQuery.docs.isNotEmpty) {
                    final String username = userQuery.docs.first.data()['username'] as String? ?? 'Jugador';
                    
                    // Sumar puntos al jugador dentro del grupo
                    final int currentScore = groupScores[username] ?? 0;
                    groupScores[username] = currentScore + pointsToAssign;
                  }
                }
              }
              
              // Guardar el mapa de puntuaciones actualizado en Firebase
              await groupRef.update(<String, dynamic>{'scores': groupScores});
            }
          }
        } catch (e) {
          print('Error actualizando estadísticas: $e');
        }

        emit(
          state.copyWith(
            status: GameStatus.finished,
            game: updatedGame,
            remainingSeconds: 0,
            currentWord: '',
            currentBag: <String>[],
            turnGuessedWords: <String>[],
            turnSkippedWords: <String>[],
          ),
        );
      }
    } else {
      // Cambio de turno normal
      final int nextTeamIndex =
          (currentGame.activeTeamIndex + 1) % currentGame.teams.length;
      updatedGame = updatedGame.copyWith(activeTeamIndex: nextTeamIndex);

      emit(
        state.copyWith(
          status: GameStatus.playing,
          game: updatedGame,
          remainingSeconds: 0,
          currentWord: '',
          currentBag: newBag,
          turnGuessedWords: <String>[],
          turnSkippedWords: <String>[],
        ),
      );
    }
  }

  void _onEndGame(EndGameEvent event, Emitter<GameState> emit) {
    _turnTimer?.cancel();
    if (state.game == null) {
      return;
    }

    final GameEntity updatedGame = state.game!.copyWith(gameStatus: 'finished');

    emit(state.copyWith(status: GameStatus.finished, game: updatedGame));
  }

  void _onStartTurn(StartTurnEvent event, Emitter<GameState> emit) {
    _turnTimer?.cancel();

    if (state.currentBag.isEmpty) {
      return;
    }

    final List<String> newBag = List<String>.from(state.currentBag);
    final String newWord = newBag.removeAt(0);

    emit(
      state.copyWith(
        remainingSeconds: state.game!.turnDurationSeconds,
        currentWord: newWord,
        currentBag: newBag,
        turnGuessedWords: <String>[],
        turnSkippedWords: <String>[],
      ),
    );

    _turnTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      add(const TickTimerEvent());
    });

    if (state.game!.teams[state.game!.activeTeamIndex].name.startsWith('IA Guess It')) {
      add(const ProcessAiTurnEvent());
    }
  }

  Future<void> _onProcessAiTurn(
    ProcessAiTurnEvent event,
    Emitter<GameState> emit,
  ) async {
    final GameEntity? game = state.game;
    if (game == null) return;

    final String teamName = game.teams[game.activeTeamIndex].name;
    final int totalWords = state.masterBag.length;
    int minWords = 1;
    int maxWords = 2;

    if (teamName.contains('Fácil')) {
      minWords = (totalWords * 0.05).clamp(1, totalWords).floor();
      maxWords = (totalWords * 0.10).clamp(minWords, totalWords).ceil();
    } else if (teamName.contains('Media')) {
      minWords = (totalWords * 0.10).clamp(1, totalWords).floor();
      maxWords = (totalWords * 0.20).clamp(minWords, totalWords).ceil();
    } else if (teamName.contains('Difícil')) {
      minWords = (totalWords * 0.20).clamp(1, totalWords).floor();
      maxWords = (totalWords * 0.35).clamp(minWords, totalWords).ceil();
    }

    final Random rnd = Random();
    if (isClosed || state.status != GameStatus.playing) return;
    
    _turnTimer?.cancel();
    
    int wordsToGuess = minWords + rnd.nextInt((maxWords - minWords) + 1);
    if (wordsToGuess > state.currentBag.length) {
      wordsToGuess = state.currentBag.length;
    }

    final List<String> newBag = List<String>.from(state.currentBag);
    final List<String> newGuessed = List<String>.from(state.turnGuessedWords);
    final List<String> newSkipped = List<String>.from(state.turnSkippedWords);

    for (int i = 0; i < wordsToGuess; i++) {
      if (newBag.isEmpty) break;
      newGuessed.add(newBag.removeAt(0));
    }

    if (newBag.isNotEmpty && rnd.nextBool()) {
      newSkipped.add(newBag.removeAt(0));
    }

    emit(state.copyWith(
      remainingSeconds: 0,
      currentWord: '',
      currentBag: newBag,
      turnGuessedWords: newGuessed,
      turnSkippedWords: newSkipped,
    ));

    add(const TimeUpEvent());
  }

  void _onTickTimer(TickTimerEvent event, Emitter<GameState> emit) {
    if (state.remainingSeconds > 0) {
      final int updatedSeconds = state.remainingSeconds - 1;
      emit(state.copyWith(remainingSeconds: updatedSeconds));
      if (updatedSeconds == 0) {
        _turnTimer?.cancel();
        add(const TimeUpEvent());
      }
    }
  }

  void _onCorrectAnswer(CorrectAnswerEvent event, Emitter<GameState> emit) {
    if (state.status == GameStatus.paused || state.remainingSeconds == 0) {
      return;
    }

    final List<String> newGuessed = List<String>.from(state.turnGuessedWords);
    if (state.currentWord.isNotEmpty) {
      newGuessed.add(state.currentWord);
    }

    final List<String> newBag = List<String>.from(state.currentBag);

    if (newBag.isEmpty) {
      _turnTimer?.cancel();
      emit(
        state.copyWith(
          currentWord: '',
          currentBag: newBag,
          turnGuessedWords: newGuessed,
        ),
      );
      add(const TimeUpEvent());
      return;
    }

    final String newWord = newBag.removeAt(0);

    emit(
      state.copyWith(
        currentWord: newWord,
        currentBag: newBag,
        turnGuessedWords: newGuessed,
      ),
    );
  }

  void _onSkipWord(SkipWordEvent event, Emitter<GameState> emit) {
    if (state.status == GameStatus.paused || state.remainingSeconds == 0) {
      return;
    }

    final List<String> newSkipped = List<String>.from(state.turnSkippedWords);
    if (state.currentWord.isNotEmpty) {
      newSkipped.add(state.currentWord);
    }

    final List<String> newBag = List<String>.from(state.currentBag);

    if (newBag.isEmpty) {
      _turnTimer?.cancel();
      emit(
        state.copyWith(
          currentWord: '',
          currentBag: newBag,
          turnSkippedWords: newSkipped,
        ),
      );
      add(const TimeUpEvent());
      return;
    }

    final String newWord = newBag.removeAt(0);

    emit(
      state.copyWith(
        currentWord: newWord,
        currentBag: newBag,
        turnSkippedWords: newSkipped,
      ),
    );
  }

  void _onPauseGame(PauseGameEvent event, Emitter<GameState> emit) {
    _turnTimer?.cancel();
    emit(state.copyWith(status: GameStatus.paused));
  }

  void _onResumeGame(ResumeGameEvent event, Emitter<GameState> emit) {
    emit(state.copyWith(status: GameStatus.playing));

    if (state.remainingSeconds > 0) {
      _turnTimer?.cancel();
      _turnTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        add(const TickTimerEvent());
      });
    }
  }

  void _onTimeUp(TimeUpEvent event, Emitter<GameState> emit) {
    _turnTimer?.cancel();
    emit(state.copyWith(status: GameStatus.turnReview));
  }

  void _onToggleWordReview(
    ToggleWordReviewEvent event,
    Emitter<GameState> emit,
  ) {
    final List<String> newGuessed = List<String>.from(state.turnGuessedWords);
    final List<String> newSkipped = List<String>.from(state.turnSkippedWords);

    if (event.wasGuessed) {
      // Mover de skipped a guessed
      newSkipped.remove(event.word);
      if (!newGuessed.contains(event.word)) {
        newGuessed.add(event.word);
      }
    } else {
      // Mover de guessed a skipped
      newGuessed.remove(event.word);
      if (!newSkipped.contains(event.word)) {
        newSkipped.add(event.word);
      }
    }

    emit(
      state.copyWith(
        turnGuessedWords: newGuessed,
        turnSkippedWords: newSkipped,
      ),
    );
  }

  Future<void> _onResetGame(
    ResetGameEvent event,
    Emitter<GameState> emit,
  ) async {
    _turnTimer?.cancel();
    emit(GameState.initial());
  }
}
