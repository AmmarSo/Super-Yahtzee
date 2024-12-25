import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_settings.dart';

class GameModeScreen extends StatelessWidget {
  const GameModeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choisir un mode de jeu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Initialiser le jeu pour le mode Solo
                Provider.of<GameProvider>(context, listen: false)
                    .initializeGame(GameMode.solo);

                // Naviguer vers l'écran du jeu
                Navigator.pushNamed(
                  context,
                  '/game',
                  arguments: GameSettings(mode: GameMode.solo),
                );
              },
              child: const Text('Solo'),
            ),
            ElevatedButton(
              onPressed: () {
                // Initialiser le jeu pour le mode Deux Joueurs
                Provider.of<GameProvider>(context, listen: false)
                    .initializeGame(GameMode.twoPlayers);

                // Naviguer vers l'écran du jeu
                Navigator.pushNamed(
                  context,
                  '/game',
                  arguments: GameSettings(mode: GameMode.twoPlayers),
                );
              },
              child: const Text('Deux Joueurs'),
            ),
          ],
        ),
      ),
    );
  }
}
