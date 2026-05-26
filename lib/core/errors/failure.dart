import 'package:equatable/equatable.dart';

/// Clase base para manejar errores y excepciones en la capa de dominio.
///
/// Permite capturar fallos de forma estructurada para devolverlos a través
/// del tipo [Either] en los repositorios.
abstract class Failure extends Equatable {
  /// Mensaje descriptivo del error ocurrido.
  final String message;

  /// Crea una instancia de [Failure].
  ///
  /// @param message El mensaje que describe el fallo.
  const Failure({required String message}) : message = message;

  @override
  List<Object?> get props => [message];
}

/// Fallo específico relacionado con errores del servidor o bases de datos externas.
class ServerFailure extends Failure {
  /// Crea una instancia de [ServerFailure].
  ///
  /// @param message El mensaje que describe el fallo en el servidor.
  const ServerFailure({required String message}) : super(message: message);
}

/// Fallo específico relacionado con errores de caché local o almacenamiento interno.
class CacheFailure extends Failure {
  /// Crea una instancia de [CacheFailure].
  ///
  /// @param message El mensaje que describe el fallo en la caché.
  const CacheFailure({required String message}) : super(message: message);
}
