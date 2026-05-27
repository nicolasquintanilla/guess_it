import 'package:flutter/material.dart';

/// Un marco (scaffold) principal reutilizable para la aplicación con diseño inmersivo y de alta calidad.
///
/// Este widget de interfaz proporciona una estructura de página base que incluye un fondo degradado,
/// iconos decorativos sutiles en las esquinas, y gestión opcional de la barra de navegación ([AppBar]),
/// botones de acción flotante, y diálogos modales de ayuda.
class PremiumScaffold extends StatelessWidget {
  @override
  final Key? key;

  /// El widget principal que se mostrará en el cuerpo del scaffold.
  final Widget child;

  /// El título a mostrar en la barra de navegación superior.
  final String? title;

  /// Indica si se debe mostrar una flecha de retroceso automática en la barra superior.
  final bool showBackArrow;

  /// Una lista opcional de widgets a renderizar en la parte derecha de la barra superior.
  final List<Widget>? actions;

  /// Un botón de acción flotante opcional para la pantalla.
  final Widget? floatingActionButton;

  /// Texto explicativo opcional. Si se provee, se añadirá automáticamente un botón de ayuda
  /// a las acciones de la barra superior que abrirá un panel inferior con este texto.
  final String? helpText;

  /// Crea una instancia de [PremiumScaffold].
  ///
  /// @param key El identificador opcional para el widget.
  /// @param child El contenido principal de la pantalla.
  /// @param title El texto del título superior (opcional).
  /// @param showBackArrow Si es verdadero, muestra el botón de volver (por defecto es true).
  /// @param actions Botones de acción extra para el [AppBar].
  /// @param floatingActionButton Un botón flotante opcional.
  /// @param helpText Texto para el modal de instrucciones.
  const PremiumScaffold({
    Key? key,
    required Widget child,
    String? title,
    bool showBackArrow = true,
    List<Widget>? actions,
    Widget? floatingActionButton,
    String? helpText,
  }) : key = key,
       child = child,
       title = title,
       showBackArrow = showBackArrow,
       actions = actions,
       floatingActionButton = floatingActionButton,
       helpText = helpText;

  /// Construye la representación visual del andamiaje premium.
  ///
  /// @param context El contexto de construcción actual.
  /// @return Un [Widget] que renderiza el scaffold con el diseño inmersivo.
  @override
  Widget build(BuildContext context) {
    final List<Widget> currentActions = List<Widget>.from(
      actions ?? <Widget>[],
    );

    if (helpText != null) {
      currentActions.insert(
        0,
        IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.white),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              backgroundColor: Colors.white,
              builder: (BuildContext ctx) {
                return Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(ctx).size.height * 0.85,
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                        top: 24.0,
                        bottom: 0,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Instrucciones',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              helpText!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }

    final bool hasAppBar =
        showBackArrow ||
        (title != null && title!.isNotEmpty) ||
        currentActions.isNotEmpty;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.deepPurple,
      resizeToAvoidBottomInset: true,
      appBar: hasAppBar
          ? AppBar(
              title: title != null
                  ? Text(title!, maxLines: 1, overflow: TextOverflow.ellipsis)
                  : null,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: showBackArrow,
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                shadows: <Shadow>[
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              actions: currentActions.isNotEmpty ? currentActions : null,
            )
          : null,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Colors.deepPurple, Colors.deepPurpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: -50,
            right: -50,
            child: Icon(
              Icons.videogame_asset,
              size: 300,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Icon(
              Icons.extension,
              size: 250,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
