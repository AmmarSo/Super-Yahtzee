import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final winner = gameProvider.players.isNotEmpty
        ? gameProvider.getWinner()
        : null; // Ajout pour éviter les erreurs si aucun joueur

    return Scaffold(
      appBar: AppBar(title: const Text('Résultats finaux')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Scores finaux',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            for (var player in gameProvider.players)
              Text(
                '${player.name}: ${player.scoreCard.calculateTotal()} points',
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 40),
            Text(
              winner != null
                  ? 'Le gagnant est : ${winner.name} 🎉'
                  : 'Partie terminée !',
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: const Text('Rejouer'),
            ),
          ],
        ),
      ),
    );
  }
}
