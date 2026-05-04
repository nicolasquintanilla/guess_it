# CONTEXTO DE NEGOCIO: Guess It! (Trabajo de Fin de Grado)

**Visión General del Producto:**
"Guess It!" es un videojuego de adivinanzas multijugador local para dispositivos móviles. Un único dispositivo actúa como "consola central" o tablero de juego, mientras los jugadores interactúan físicamente a su alrededor. El objetivo principal es ofrecer una experiencia fluida, robusta y a prueba de interrupciones (si la app se minimiza, el estado del juego no debe perderse).

**Reglas de Dominio y Usuarios:**
El sistema maneja dos tipos de perfiles de jugador en el dispositivo principal:

1. **Host (Anfitrión):**
   - Es el propietario del dispositivo.
   - Requiere registro e inicio de sesión (Firebase Auth).
   - Su perfil, rango, estadísticas históricas y preferencias se persisten en la nube (Firestore).

2. **Guest (Invitado):**
   - Juega de forma casual en el dispositivo del Host.
   - NO requiere registro ni conexión a internet.
   - Sus datos y progreso son estrictamente temporales y se persisten únicamente en la memoria local del dispositivo mediante la caché de la aplicación. NUNCA se sincronizan con la base de datos externa.

**Flujo de Navegación Principal:**
1. Pantalla de Carga (Splash)
2. Autenticación (Login/Registro/Jugar como Invitado)
3. Hub Principal (Menú)
4. Configuración de Partida (Equipos, tiempo, rondas)
5. Bucle de Juego (Temporizador, aciertos, fallos)
6. Sistema de VAR (Revisión manual de respuestas dadas)
7. Resultados y actualización de estadísticas.

**Consideraciones Críticas:**
- La arquitectura debe priorizar la retención del estado local por encima de todo. Un usuario debe poder retomar la partida exactamente donde la dejó si la app se suspende por el sistema operativo.