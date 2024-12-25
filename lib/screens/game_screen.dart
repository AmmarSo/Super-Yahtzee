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

    return Scaffold(
      backgroundColor: const Color(0xFF0099FF),
      body: SafeArea(
        child: Column(
          children: [
            // Section supérieure : Infos joueurs
            _buildTopBar(gameProvider),

            // Section centrale : Grille des scores divisée en catégories gauche/droite
            Expanded(
              child: Row(
                children: [
                  _buildLeftScoreColumn(gameProvider),
                  _buildRightScoreColumn(gameProvider),
                ],
              ),
            ),

            // Section inférieure : Dés et bouton d'action
            _buildDiceSection(gameProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(GameProvider gameProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: const Color(0xFF007ACC),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPlayerInfo('Joueur 1', gameProvider.players[0].scoreCard.calculateTotal(), Colors.blue),
          if (gameProvider.players.length > 1)
            _buildPlayerInfo('Joueur 2', gameProvider.players[1].scoreCard.calculateTotal(), Colors.green),
        ],
      ),
    );
  }

  Widget _buildPlayerInfo(String playerName, int score, Color color) {
    return Column(
      children: [
        Text(
          playerName,
          style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        CircleAvatar(
          backgroundColor: color,
          radius: 20,
          child: Text(
            score.toString(),
            style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildLeftScoreColumn(GameProvider gameProvider) {
    final leftCategories = [
      'Ones',
      'Twos',
      'Threes',
      'Fours',
      'Fives',
      'Sixes',
    ];

    return Expanded(
      child: Container(
        color: const Color(0xFF00A3FF),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: leftCategories.length,
                itemBuilder: (context, index) {
                  final category = leftCategories[index];
                  final player1Score = gameProvider.players[0].scoreCard.scores[category];
                  final player2Score = gameProvider.players.length > 1
                      ? gameProvider.players[1].scoreCard.scores[category]
                      : null;

                  return GestureDetector(
                    onTap: () {
                      if (gameProvider.rollsLeft == 0) {
                        try {
                          gameProvider.addScore(category);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: _getDiceIcon(index + 1),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                category,
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  player1Score?.toString() ?? '-',
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                if (player2Score != null) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    player2Score?.toString() ?? '-',
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20), // Ajustement de l'espacement avec le bas
            _buildBonusSection(gameProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildBonusSection(GameProvider gameProvider) {
    final player1Score = gameProvider.players[0].scoreCard.calculateUpperSection();
    final player2Score = gameProvider.players.length > 1
        ? gameProvider.players[1].scoreCard.calculateUpperSection()
        : null;
    final player1BonusAchieved = player1Score >= 63;
    final player2BonusAchieved = player2Score != null && player2Score >= 63;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFF007ACC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Section Bonus',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Joueur 1: $player1Score/63',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: player1BonusAchieved ? Colors.yellow : Colors.white,
                ),
              ),
              if (player1BonusAchieved)
                const Icon(
                  Icons.check_circle,
                  color: Colors.yellow,
                ),
              if (player2Score != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Joueur 2: $player2Score/63',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: player2BonusAchieved ? Colors.yellow : Colors.white,
                  ),
                ),
                if (player2BonusAchieved)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.yellow,
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRightScoreColumn(GameProvider gameProvider) {
    final rightCategories = [
      'Three of a Kind',
      'Four of a Kind',
      'Full House',
      'Small Straight',
      'Large Straight',
      'Yahtzee',
      'Chance'
    ];

    return Expanded(
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: rightCategories.length,
          itemBuilder: (context, index) {
            final category = rightCategories[index];
            final player1Score = gameProvider.players[0].scoreCard.scores[category];
            final player2Score = gameProvider.players.length > 1
                ? gameProvider.players[1].scoreCard.scores[category]
                : null;

            return GestureDetector(
              onTap: () {
                if (gameProvider.rollsLeft == 0) {
                  try {
                    gameProvider.addScore(category);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: _getCategoryIcon(category),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            player1Score?.toString() ?? '-',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          if (player2Score != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              player2Score?.toString() ?? '-',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDiceSection(GameProvider gameProvider) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.blue[800],
      child: Column(
        children: [
          // Dés
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: gameProvider.diceList.map((dice) {
              return GestureDetector(
                onTap: () => gameProvider.toggleDiceLock(gameProvider.diceList.indexOf(dice)),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: dice.isLocked ? Colors.orangeAccent : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      dice.value?.toString() ?? '-',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          // Bouton d'action
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: gameProvider.rollsLeft > 0 ? () {
              gameProvider.rollDice();
              // Réactiver les catégories après un lancer
            } : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Lancer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 14,
                  child: Text(
                    gameProvider.rollsLeft.toString(),
                    style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCategoryIcon(String category) {
    switch (category) {
      case 'Three of a Kind':
        return const Text('3x', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white));
      case 'Four of a Kind':
        return const Text('4x', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white));
      case 'Full House':
        return const Icon(Icons.home, color: Colors.white);
      case 'Small Straight':
        return const Icon(Icons.trending_flat, color: Colors.white);
      case 'Large Straight':
        return const Icon(Icons.trending_up, color: Colors.white);
      case 'Yahtzee':
        return const Icon(Icons.star, color: Colors.yellow);
      case 'Chance':
        return const Icon(Icons.help, color: Colors.white);
      default:
        return const Icon(Icons.help_outline, color: Colors.black);
    }
  }

  Widget _getDiceIcon(int value) {
    switch (value) {
      case 1:
        return const Text('⚀', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white));
      case 2:
        return const Text('⚁', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white));
      case 3:
        return const Text('⚂', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white));
      case 4:
        return const Text('⚃', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white));
      case 5:
        return const Text('⚄', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white));
      case 6:
        return const Text('⚅', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white));
      default:
        return const Text('?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white));
    }
  }
}
