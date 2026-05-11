import 'package:flutter/material.dart';

class PremiumScaffold extends StatelessWidget {
  @override
  final Key? key;
  final Widget child;
  final String? title;
  final bool showBackArrow;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const PremiumScaffold({
    Key? key,
    required Widget child,
    String? title,
    bool showBackArrow = true,
    List<Widget>? actions,
    Widget? floatingActionButton,
  })  : key = key,
        child = child,
        title = title,
        showBackArrow = showBackArrow,
        actions = actions,
        floatingActionButton = floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: showBackArrow,
              actions: actions,
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
