import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_it/features/ranking/presentation/bloc/ranking_bloc.dart';
import 'package:guess_it/features/ranking/domain/entities/ranking_entity.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clasificación Mundial'),
      ),
      body: BlocBuilder<RankingBloc, RankingState>(
        builder: (BuildContext context, RankingState state) {
          if (state is RankingInitial || state is RankingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RankingError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          } else if (state is RankingLoaded) {
            final List<RankingEntity> rankings = state.rankings;

            if (rankings.isEmpty) {
              return const Center(
                child: Text('Aún no hay puntuaciones registradas.'),
              );
            }

            return ListView.builder(
              itemCount: rankings.length,
              itemBuilder: (BuildContext context, int index) {
                final RankingEntity ranking = rankings[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      ranking.hostName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Victorias: ${ranking.totalMatchesWon}'),
                    trailing: Text(
                      '${ranking.totalPointsScored} pts',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.green),
                    ),
                  ),
                );
              },
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
