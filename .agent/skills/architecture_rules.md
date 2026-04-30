# Reglas de Desarrollo para Agentes en Guess It!

1. **Clean Architecture Estricta:** Respeta siempre la separación en capas (Domain, Data, Presentation). La capa de Presentación NUNCA debe comunicarse directamente con Data o Firebase; todo debe pasar a través de los UseCases del Dominio.
2. **Tipado de Fechas:** Todos los campos de fecha y hora (date and time) deben ser representados estrictamente como `String`. No utilices objetos `DateTime` para evitar problemas de parseo y serialización con la base de datos NoSQL.
3. **Constructores y Parámetros:** Declara siempre todos los parámetros explícitamente en el código. Está estrictamente prohibido el uso de `super` para la inicialización abreviada en los constructores o en la herencia. Desarrolla la asignación completa de variables.