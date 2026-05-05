import 'package:guess_it/features/ranking/domain/entities/ranking_entity.dart';
import 'package:guess_it/features/ranking/domain/repositories/ranking_repository.dart';
import 'package:guess_it/features/ranking/data/datasources/ranking_remote_data_source.dart';

class RankingRepositoryImpl implements RankingRepository {
  final RankingRemoteDataSource remoteDataSource;

  const RankingRepositoryImpl({
    required RankingRemoteDataSource remoteDataSource,
  }) : remoteDataSource = remoteDataSource;

  @override
  Future<void> addWinAndPoints({required int points}) async {
    return remoteDataSource.addWinAndPoints(points: points);
  }

  @override
  Future<List<RankingEntity>> getGlobalRanking() async {
    return remoteDataSource.getGlobalRanking();
  }
}
