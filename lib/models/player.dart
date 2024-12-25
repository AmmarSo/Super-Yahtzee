import 'score_card.dart';

class Player {
  String name; // Nom du joueur
  ScoreCard scoreCard; // Feuille de score associée

  Player({required this.name}) : scoreCard = ScoreCard();
}
