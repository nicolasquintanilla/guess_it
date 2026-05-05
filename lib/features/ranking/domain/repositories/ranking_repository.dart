import 'package:guess_it/features/ranking/domain/entities/ranking_entity.dart';

abstract class RankingRepository {
  Future<void> addWinAndPoints({required int points});
  Future<List<RankingEntity>> getGlobalRanking();
}
