import 'package:flutter/material.dart';

class EmptyGroupsView extends StatelessWidget {
  const EmptyGroupsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.groups, color: Colors.white, size: 120),
          SizedBox(height: 24),
          Text(
            'Tus grupos aparecerán aquí',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
