import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/game_settings.dart';
import '../providers/game_provider.dart';

class GameScreen extends StatelessWidget {
  final GameMode mode;

  const GameScreen({Key? key, required this.mode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    if (gameProvider.players.isEmpty || gameProvider.diceList.isEmpty) {
      return const Center(
        child: Text(
          "Erreur : Configuration invalide.",
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      );
    }

    final currentPlayer = gameProvider.players[gameProvider.currentPlayerIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yahtzee - ${mode == GameMode.solo ? 'Solo' : 'Deux Joueurs'}',
          style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Row(
        children: [
          // Colonne de gauche : Grille des scores
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Grille des scores',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(thickness: 1),
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentPlayer.scoreCard.scores.length,
                      itemBuilder: (context, index) {
                        final category = currentPlayer.scoreCard.scores.keys.elementAt(index);
                        final score = currentPlayer.scoreCard.scores[category];
                        final icon = _getCategoryIcon(category);

                        return ListTile(
                          leading: icon,
                          title: Text(
                            category,
                            style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            score?.toString() ?? '-',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          onTap: () {
                            try {
                              gameProvider.addScore(category);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Colonne de droite : Dés et actions
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dés
                  SizedBox(
                    height: 150,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: gameProvider.diceList.length,
                      itemBuilder: (context, index) {
                        final dice = gameProvider.diceList[index];
                        return GestureDetector(
                          onTap: () => gameProvider.toggleDiceLock(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: dice.isLocked ? Colors.green[200] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: dice.isLocked ? Colors.green : Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                dice.value?.toString() ?? '-',
                                style: GoogleFonts.roboto(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Boutons d'action
                  Column(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        icon: const Icon(Icons.casino),
                        label: Text(
                          'Lancer (${gameProvider.rollsLeft})',
                          style: const TextStyle(fontSize: 16),
                        ),
                        onPressed: gameProvider.rollsLeft > 0 ? gameProvider.rollDice : null,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        icon: const Icon(Icons.check_circle),
                        label: const Text(
                          'Fin du tour',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () => gameProvider.nextTurn(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Retourne une icône ou un widget graphique en fonction de la catégorie
  Widget _getCategoryIcon(String category) {
    switch (category) {
      case 'Ones':
        return const Icon(Icons.looks_one, color: Colors.orange);
      case 'Twos':
        return const Icon(Icons.looks_two, color: Colors.orange);
      case 'Threes':
        return const Icon(Icons.filter_3, color: Colors.orange);
      case 'Fours':
        return const Icon(Icons.filter_4, color: Colors.orange);
      case 'Fives':
        return const Icon(Icons.filter_5, color: Colors.orange);
      case 'Sixes':
        return const Icon(Icons.filter_6, color: Colors.orange);
      case 'Three of a Kind':
        return const Text('3x', style: TextStyle(fontSize: 16, color: Colors.red));
      case 'Four of a Kind':
        return const Text('4x', style: TextStyle(fontSize: 16, color: Colors.red));
      case 'Full House':
        return const Icon(Icons.home, color: Colors.purple);
      case 'Small Straight':
        return const Icon(Icons.trending_flat, color: Colors.blue);
      case 'Large Straight':
        return const Icon(Icons.trending_up, color: Colors.blue);
      case 'Yahtzee':
        return const Icon(Icons.star, color: Colors.yellow);
      case 'Chance':
        return const Icon(Icons.help, color: Colors.green);
      default:
        return const Icon(Icons.error, color: Colors.red);
    }
  }
}
