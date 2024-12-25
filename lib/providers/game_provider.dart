import 'package:flutter/material.dart';
import '../models/dice.dart';
import '../models/player.dart';
import '../models/game_settings.dart';

class GameProvider with ChangeNotifier {
  late GameMode mode;
  List<Player> players = []; // Initialisation pour éviter LateInitializationError
  int currentPlayerIndex = 0;

  List<Dice> diceList = List.generate(5, (_) => Dice());
  int rollsLeft = 3;

  void initializeGame(GameMode selectedMode) {
    mode = selectedMode;

    if (mode == GameMode.solo) {
      players = [Player(name: 'Joueur Solo')];
    } else {
      players = [
        Player(name: 'Joueur 1'),
        Player(name: 'Joueur 2'),
      ];
    }

    currentPlayerIndex = 0;
    resetDice();
    rollsLeft = 3;
    notifyListeners();
  }

  void rollDice() {
    if (rollsLeft > 0) {
      for (var dice in diceList) {
        if (!dice.isLocked) {
          dice.roll();
        }
      }
      rollsLeft--;
      notifyListeners();
    } else {
      throw Exception("Aucun lancer restant !");
    }
  }

  void toggleDiceLock(int index) {
    diceList[index].toggleLock();
    notifyListeners();
  }

  void resetDice() {
    for (var dice in diceList) {
      dice.reset(); // Réinitialise chaque dé à son état initial (vide)
    }
    rollsLeft = 3;
    notifyListeners();
  }

  void nextTurn() {
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
    resetDice();
    notifyListeners();
  }

  void addScore(String category) {
    final currentPlayer = players[currentPlayerIndex];
    if (!currentPlayer.scoreCard.isCategoryUsed(category)) {
      int score = calculateScoreForCategory(category);
      currentPlayer.scoreCard.setScore(category, score);
      resetDice();
      nextTurn();
      notifyListeners();
    } else {
      throw Exception('La catégorie $category est déjà utilisée.');
    }
  }

  int calculateScoreForCategory(String category) {
    final values = diceList.map((d) => d.value ?? 0).toList();
    values.sort();

    switch (category) {
      case 'Ones':
        return values.where((v) => v == 1).fold(0, (sum, v) => sum + v);
      case 'Twos':
        return values.where((v) => v == 2).fold(0, (sum, v) => sum + v);
      case 'Threes':
        return values.where((v) => v == 3).fold(0, (sum, v) => sum + v);
      case 'Fours':
        return values.where((v) => v == 4).fold(0, (sum, v) => sum + v);
      case 'Fives':
        return values.where((v) => v == 5).fold(0, (sum, v) => sum + v);
      case 'Sixes':
        return values.where((v) => v == 6).fold(0, (sum, v) => sum + v);
      case 'Three of a Kind':
        return values.any((v) => values.where((x) => x == v).length >= 3)
            ? values.fold(0, (sum, v) => sum + v)
            : 0;
      case 'Four of a Kind':
        return values.any((v) => values.where((x) => x == v).length >= 4)
            ? values.fold(0, (sum, v) => sum + v)
            : 0;
      case 'Full House':
        final uniqueValues = values.toSet().toList();
        return uniqueValues.length == 2 &&
                (values.where((v) => v == uniqueValues[0]).length == 3 ||
                    values.where((v) => v == uniqueValues[1]).length == 3)
            ? 25
            : 0;
      case 'Small Straight':
        return [1, 2, 3, 4].every((v) => values.contains(v)) ||
                [2, 3, 4, 5].every((v) => values.contains(v)) ||
                [3, 4, 5, 6].every((v) => values.contains(v))
            ? 30
            : 0;
      case 'Large Straight':
        return [1, 2, 3, 4, 5].every((v) => values.contains(v)) ||
                [2, 3, 4, 5, 6].every((v) => values.contains(v))
            ? 40
            : 0;
      case 'Yahtzee':
        return values.every((v) => v == values[0]) ? 50 : 0;
      case 'Chance':
        return values.fold(0, (sum, v) => sum + v);
      default:
        return 0;
    }
  }

  Player? getWinner() {
    if (players.isEmpty) return null;

    return players.reduce((a, b) =>
        a.scoreCard.calculateTotal() > b.scoreCard.calculateTotal() ? a : b);
  }
}
