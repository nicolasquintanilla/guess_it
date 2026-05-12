import 'package:flutter/material.dart';

class PremiumScaffold extends StatelessWidget {
  @override
  final Key? key;
  final Widget child;
  final String? title;
  final bool showBackArrow;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final String? helpText;

  const PremiumScaffold({
    Key? key,
    required Widget child,
    String? title,
    bool showBackArrow = true,
    List<Widget>? actions,
    Widget? floatingActionButton,
    String? helpText,
  })  : key = key,
        child = child,
        title = title,
        showBackArrow = showBackArrow,
        actions = actions,
        floatingActionButton = floatingActionButton,
        helpText = helpText;

  @override
  Widget build(BuildContext context) {
    final List<Widget> currentActions = List<Widget>.from(actions ?? <Widget>[]);
    if (helpText != null) {
      currentActions.insert(
        0,
        IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.white),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              backgroundColor: Colors.white,
              builder: (BuildContext ctx) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
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
                );
              },
            );
          },
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: showBackArrow,
              actions: currentActions.isNotEmpty ? currentActions : null,
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            )
          : null,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: <Widget>[
          Container(
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
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
