import 'package:flutter/material.dart';

class GuestProfileView extends StatelessWidget {
  const GuestProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.no_accounts,
              size: 150,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 32),
            const Text(
              'Los invitados no guardan estadísticas. ¡Regístrate para competir!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
