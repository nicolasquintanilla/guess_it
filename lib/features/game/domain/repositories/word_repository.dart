abstract class WordRepository {
  Future<List<String>> generateWordBag(List<String> userWords, int targetCount);
}
