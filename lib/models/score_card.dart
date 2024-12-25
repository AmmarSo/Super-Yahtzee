class ScoreCard {
  Map<String, int?> scores = {
    'Ones': null,
    'Twos': null,
    'Threes': null,
    'Fours': null,
    'Fives': null,
    'Sixes': null,
    'Three of a Kind': null,
    'Four of a Kind': null,
    'Full House': null,
    'Small Straight': null,
    'Large Straight': null,
    'Yahtzee': null,
    'Chance': null,
  };

  // Méthode pour calculer le score total
  int calculateTotal() {
    return scores.values.where((score) => score != null).fold(0, (a, b) => a + (b ?? 0));
  }

  // Vérifie si une catégorie est utilisée
  bool isCategoryUsed(String category) {
    return scores[category] != null;
  }

  // Définit un score pour une catégorie
  void setScore(String category, int value) {
    if (isCategoryUsed(category)) {
      throw Exception('La catégorie $category est déjà utilisée.');
    }
    scores[category] = value;
  }

  // Méthode pour calculer la somme de la section supérieure
  int calculateUpperSection() {
    final upperCategories = ['Ones', 'Twos', 'Threes', 'Fours', 'Fives', 'Sixes'];
    return upperCategories.fold(0, (sum, category) {
      return sum + (scores[category] ?? 0);
    });
  }
}
