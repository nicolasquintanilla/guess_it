import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/ranking/presentation/bloc/ranking_bloc.dart';
import 'package:guess_it/features/ranking/domain/entities/ranking_entity.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';
import 'package:guess_it/features/ranking/presentation/widgets/ranking_podium.dart';
import 'package:guess_it/features/ranking/presentation/widgets/ranking_list_item.dart';

/// Pantalla principal que muestra la clasificación global de jugadores.
///
/// Obtiene y renderiza la lista de usuarios ordenados según su eficacia
/// y número de victorias. Destaca a los 3 mejores mediante el widget `RankingPodium`
/// y muestra el resto en una lista continua con `RankingListItem`.
class RankingPage extends StatefulWidget {
  @override
  final Key? key;

  /// Crea una instancia de [RankingPage].
  ///
  /// @param key El identificador opcional para el widget.
  const RankingPage({Key? key}) : key = key;

  /// Crea el estado mutable necesario para esta pantalla.
  ///
  /// @return Una instancia de [_RankingPageState].
  @override
  State<RankingPage> createState() {
    return _RankingPageState();
  }
}

class _RankingPageState extends State<RankingPage> {
  static const Map<String, String> _availableAvatars = <String, String>{
    'arana': 'assets/avatars/arana.png',
    'astronauta': 'assets/avatars/astronauta.png',
    'auto-de-choque': 'assets/avatars/auto-de-choque.png',
    'buho': 'assets/avatars/buho.png',
    'cangrejo': 'assets/avatars/cangrejo.png',
    'casco-romano': 'assets/avatars/casco-romano.png',
    'cerdo': 'assets/avatars/cerdo.png',
    'cerezas': 'assets/avatars/cerezas.png',
    'chile': 'assets/avatars/chile.png',
    'coche-rc': 'assets/avatars/coche-rc.png',
    'cohete': 'assets/avatars/cohete.png',
    'craneo': 'assets/avatars/craneo.png',
    'dinosaurio': 'assets/avatars/dinosaurio.png',
    'elefante': 'assets/avatars/elefante.png',
    'extraterrestre': 'assets/avatars/extraterrestre.png',
    'flecha': 'assets/avatars/flecha.png',
    'futbol': 'assets/avatars/futbol.png',
    'gato': 'assets/avatars/gato.png',
    'gorila': 'assets/avatars/gorila.png',
    'hueso': 'assets/avatars/hueso.png',
    'juego-de-azar': 'assets/avatars/juego-de-azar.png',
    'leon': 'assets/avatars/leon.png',
    'momia': 'assets/avatars/momia.png',
    'ninja': 'assets/avatars/ninja.png',
    'ojo': 'assets/avatars/ojo.png',
    'ornitorrinco': 'assets/avatars/ornitorrinco.png',
    'oveja': 'assets/avatars/oveja.png',
    'pistola-de-agua': 'assets/avatars/pistola-de-agua.png',
    'pollo': 'assets/avatars/pollo.png',
    'robot': 'assets/avatars/robot.png',
    'rosquilla': 'assets/avatars/rosquilla.png',
    'saturno': 'assets/avatars/saturno.png',
    'serpiente': 'assets/avatars/serpiente.png',
    'shuriken': 'assets/avatars/shuriken.png',
    'soldado': 'assets/avatars/soldado.png',
    'tallarines': 'assets/avatars/tallarines.png',
    'tortuga': 'assets/avatars/tortuga.png',
    'trofeo': 'assets/avatars/trofeo.png',
    'vaso': 'assets/avatars/vaso.png',
  };

  @override
  void initState() {
    super.initState();
    context.read<RankingBloc>().add(const FetchRankingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: 'Ranking Global',
      helpText:
          '¡El Salón de la Fama Global!\n\n'
          'Aquí se muestran los mejores jugadores de Guess It a nivel mundial.\n\n'
          '🏆 ¿Cómo se calculan los puntos?\n'
          'Cada vez que juegas una partida y tu equipo gana, sumas 1 Victoria a tu perfil. Además, todas las palabras que tu equipo adivine correctamente se sumarán a tus "Puntos Totales".\n\n'
          '⚡ El Podio:\n'
          'Los tres jugadores con más victorias aparecerán destacados en lo más alto (Oro, Plata y Bronce).\n\n'
          'Nota: Solo las partidas jugadas Humanos vs Humanos y mínimo con una cuenta registrada (no como invitado) cuentan para esta clasificación.',
      child: BlocBuilder<RankingBloc, RankingState>(
        builder: (BuildContext context, RankingState state) {
          if (state is RankingInitial || state is RankingLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (state is RankingError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.redAccent, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          } else if (state is RankingLoaded) {
            final List<RankingEntity> sortedRankings =
                List<RankingEntity>.from(state.rankings)..sort(
                  (RankingEntity a, RankingEntity b) =>
                      b.rankScore.compareTo(a.rankScore),
                );

            if (sortedRankings.isEmpty) {
              return const Center(
                child: Text(
                  'Aún no hay puntuaciones registradas.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            final List<RankingEntity> top3 = sortedRankings.take(3).toList();
            final List<RankingEntity> rest = sortedRankings.skip(3).toList();

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 24),
                  if (top3.isNotEmpty)
                    RankingPodium(top3: top3, avatars: _availableAvatars),
                  const SizedBox(height: 48),
                  if (rest.isNotEmpty)
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        top: 24,
                        left: 16,
                        right: 16,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rest.length,
                        itemBuilder: (BuildContext context, int index) {
                          final RankingEntity user = rest[index];
                          final int rank = index + 4;

                          return RankingListItem(
                            user: user,
                            rank: rank,
                            avatars: _availableAvatars,
                          );
                        },
                      ),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        'No hay más jugadores.',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
