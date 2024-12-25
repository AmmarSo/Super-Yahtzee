import 'package:flutter/material.dart';

class DiceWidget extends StatelessWidget {
  final int value; // Valeur actuelle du dé (1 à 6)
  final bool isLocked; // État verrouillé/déverrouillé du dé
  final VoidCallback onToggleLock; // Action pour verrouiller/déverrouiller
  final VoidCallback onRoll; // Action pour relancer le dé

  DiceWidget({
    required this.value,
    required this.isLocked,
    required this.onToggleLock,
    required this.onRoll,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggleLock,
      child: Column(
        children: [
          Text(
            isLocked ? '🔒' : '🎲',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 10),
          CircleAvatar(
            radius: 30,
            backgroundColor: isLocked ? Colors.red : Colors.blue,
            child: Text(
              value.toString(),
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
