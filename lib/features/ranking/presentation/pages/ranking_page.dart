import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/ranking/presentation/bloc/ranking_bloc.dart';
import 'package:guess_it/features/ranking/domain/entities/ranking_entity.dart';
import 'package:guess_it/core/widgets/premium_scaffold.dart';

class RankingPage extends StatefulWidget {
  @override
  final Key? key;

  const RankingPage({Key? key}) : key = key;

  @override
  State<RankingPage> createState() {
    return _RankingPageState();
  }
}

class _RankingPageState extends State<RankingPage> {
  @override
  void initState() {
    super.initState();
    context.read<RankingBloc>().add(const FetchRankingEvent());
  }

  Widget _buildPodiumAvatar(RankingEntity user, int rank) {
    final Map<String, IconData> availableAvatars = const <String, IconData>{
      'default': Icons.account_circle, 'robot': Icons.smart_toy, 'alien': Icons.adb,
      'ninja': Icons.visibility, 'pet': Icons.pets, 'rocket': Icons.rocket_launch,
      'gamepad': Icons.sports_esports, 'diamond': Icons.diamond, 'star': Icons.star,
      'fire': Icons.local_fire_department,
    };
    final IconData userIcon = availableAvatars[user.avatar] ?? Icons.person;

    final bool isFirst = rank == 1;
    final double size = isFirst ? 110.0 : 85.0;
    
    Color podiumColor;
    if (rank == 1) {
      podiumColor = const Color(0xFFFFD700); // Oro
    } else if (rank == 2) {
      podiumColor = const Color(0xFFC0C0C0); // Plata
    } else {
      podiumColor = const Color(0xFFCD7F32); // Bronce
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                  border: Border.all(color: podiumColor, width: isFirst ? 4 : 3),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: podiumColor.withOpacity(0.5),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(userIcon, size: size * 0.5, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: podiumColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Text(
                    '#$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.hostName,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isFirst ? FontWeight.w900 : FontWeight.bold,
            fontSize: isFirst ? 20 : 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          '${user.victories} Victorias',
          style: TextStyle(
            color: Colors.white70,
            fontSize: isFirst ? 14 : 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: 'Ranking Global',
      helpText: '¡El Salón de la Fama Global!\n\n'
          'Aquí se muestran los mejores jugadores de Guess It a nivel mundial.\n\n'
          '🏆 ¿Cómo se calculan los puntos?\n'
          'Cada vez que juegas una partida y tu equipo gana, sumas 1 Victoria a tu perfil. Además, todas las palabras que tu equipo adivine correctamente se sumarán a tus "Puntos Totales".\n\n'
          '⚡ El Podio:\n'
          'Los tres jugadores con más victorias aparecerán destacados en lo más alto (Oro, Plata y Bronce).\n\n'
          'Nota: Solo las partidas jugadas con una cuenta registrada (no como invitado) cuentan para esta clasificación.',
      child: BlocBuilder<RankingBloc, RankingState>(
        builder: (BuildContext context, RankingState state) {
          if (state is RankingInitial || state is RankingLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (state is RankingError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.redAccent, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          } else if (state is RankingLoaded) {
            final List<RankingEntity> sortedRankings = List<RankingEntity>.from(state.rankings)
              ..sort((RankingEntity a, RankingEntity b) => b.rankScore.compareTo(a.rankScore));

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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        height: 240,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            if (top3.length >= 2)
                              Expanded(child: _buildPodiumAvatar(top3[1], 2)),
                            if (top3.isNotEmpty)
                              Expanded(child: Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: _buildPodiumAvatar(top3[0], 1),
                              )),
                            if (top3.length >= 3)
                              Expanded(child: _buildPodiumAvatar(top3[2], 3))
                            else if (top3.length == 2)
                              const Expanded(child: SizedBox()),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 48),
                  if (rest.isNotEmpty)
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                      ),
                      padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rest.length,
                        itemBuilder: (BuildContext context, int index) {
                          final RankingEntity user = rest[index];
                          final int rank = index + 4;

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            color: Colors.white,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              leading: Text(
                                '#$rank',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                              title: Text(
                                user.hostName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    '${user.victories} Victorias',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  Text(
                                    '${user.totalPointsScored} pts',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
