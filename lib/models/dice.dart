import 'dart:math';

class Dice {
  int? value; // Valeur actuelle du dé (null par défaut)
  bool isLocked; // Indique si le dé est verrouillé

  Dice({this.value, this.isLocked = false});

  // Méthode pour lancer le dé (si non verrouillé)
  void roll() {
    if (!isLocked) {
      value = Random().nextInt(6) + 1; // Génère une valeur entre 1 et 6
    }
  }

  // Méthode pour verrouiller/déverrouiller un dé
  void toggleLock() {
    isLocked = !isLocked;
  }

  // Réinitialise le dé à un état vide
  void reset() {
    value = null;
    isLocked = false;
  }
}
