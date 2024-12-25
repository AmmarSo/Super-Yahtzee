import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final String name; // Nom du joueur
  final int totalScore; // Score total du joueur
  final bool isActive; // Indique si c'est le tour du joueur

  PlayerCard({
    required this.name,
    required this.totalScore,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isActive ? Colors.green[100] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Score: $totalScore',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
