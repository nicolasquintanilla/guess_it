/// Contrato del repositorio encargado de gestionar el diccionario de palabras.
///
/// Define las operaciones para la obtención y generación de la "bolsa de palabras"
/// que se utilizará durante las rondas de la partida.
abstract class WordRepository {
  /// Genera una lista final de palabras para la partida.
  ///
  /// Combina las palabras introducidas manualmente por los usuarios ([userWords])
  /// con palabras adicionales del diccionario interno si no se alcanza la cantidad
  /// requerida ([targetCount]).
  ///
  /// @param userWords Lista de palabras personalizadas introducidas por los jugadores.
  /// @param targetCount Cantidad total de palabras necesarias para la partida.
  /// @return Un [Future] que se resuelve a la lista completa de palabras aleatorias.
  Future<List<String>> generateWordBag(List<String> userWords, int targetCount);
}
