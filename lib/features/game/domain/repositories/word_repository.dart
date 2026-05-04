import 'dart:math';
import 'package:guess_it/core/constants/dictionary_constants.dart';

class WordRepository {
  List<String> generateWordBag(List<String> userWords, int targetCount) {
    final List<String> bag = List<String>.from(userWords);
    final int missingCount = targetCount - userWords.length;

    if (missingCount > 0) {
      // Filter out words already in userWords to avoid duplicates
      final List<String> availableWords = globalDictionary
          .where((String word) => !userWords.contains(word))
          .toList();

      final Random random = Random();
      
      for (int i = 0; i < missingCount; i++) {
        if (availableWords.isEmpty) {
          break; // Fallback if dictionary runs out of words
        }
        final int randomIndex = random.nextInt(availableWords.length);
        bag.add(availableWords[randomIndex]);
        availableWords.removeAt(randomIndex); // Ensure no duplicates from dictionary
      }
    }

    bag.shuffle();
    return bag;
  }
}
