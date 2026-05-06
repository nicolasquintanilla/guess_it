import 'package:guess_it/features/game/domain/repositories/word_repository.dart';
import 'package:guess_it/features/game/data/datasources/word_remote_data_source.dart';

class WordRepositoryImpl implements WordRepository {
  final WordRemoteDataSource remoteDataSource;

  const WordRepositoryImpl({
    required WordRemoteDataSource remoteDataSource,
  }) : remoteDataSource = remoteDataSource;

  @override
  Future<List<String>> generateWordBag(List<String> userWords, int targetCount) async {
    final List<String> systemWords = await remoteDataSource.getSystemWords();
    
    // Barajamos el diccionario remoto
    systemWords.shuffle();

    // Fusionamos priorizando las palabras del usuario
    final List<String> mergedList = <String>[...userWords, ...systemWords];

    // Eliminamos duplicados pasando por un Set, luego recortamos al tamaño objetivo
    final List<String> finalBag = mergedList.toSet().take(targetCount).toList();

    // Última entropía para camuflar las inyectadas
    finalBag.shuffle();

    return finalBag;
  }
}
