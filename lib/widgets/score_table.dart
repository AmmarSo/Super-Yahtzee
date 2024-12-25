import 'package:flutter/material.dart';

class ScoreTable extends StatelessWidget {
  final Map<String, int?> scores; // Feuille de score actuelle
  final Function(String category) onSelectCategory; // Action lors de la sélection d’une catégorie

  ScoreTable({
    required this.scores,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: scores.entries.map((entry) {
        return ListTile(
          title: Text(entry.key),
          trailing: entry.value != null
              ? Text(entry.value.toString())
              : ElevatedButton(
                  onPressed: () {
                    onSelectCategory(entry.key);
                  },
                  child: Text('Choisir'),
                ),
        );
      }).toList(),
    );
  }
}
