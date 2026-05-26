import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameSettingsCard extends StatelessWidget {
  final TextEditingController countController;
  final int teamCount;
  final int selectedHostIndex;
  final int selectedTurnDuration;
  final Function(int) onHostSelected;
  final Function(int) onDurationChanged;

  const GameSettingsCard({
    Key? key,
    required this.countController,
    required this.teamCount,
    required this.selectedHostIndex,
    required this.selectedTurnDuration,
    required this.onHostSelected,
    required this.onDurationChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Ajustes de Partida',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: countController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad total de palabras',
                hintText: 'Ej. 30, 40, 60',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                prefixIcon: Icon(Icons.format_list_numbered),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '¿En qué equipo juegas tú (Anfitrión)?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List<Widget>.generate(teamCount, (int index) {
                final bool isSelected = selectedHostIndex == index;
                return ChoiceChip(
                  label: Text('Equipo ${index + 1}'),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    if (selected && selectedHostIndex != index) {
                      onHostSelected(index);
                    }
                  },
                  selectedColor: Colors.purple.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.purple
                        : Colors.black87,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            const Text(
              'Duración del turno (segundos)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: selectedTurnDuration,
                children: const <int, Widget>{
                  30: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('30s'),
                  ),
                  45: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('45s'),
                  ),
                  60: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('60s'),
                  ),
                },
                onValueChanged: (int? value) {
                  if (value != null) {
                    onDurationChanged(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
