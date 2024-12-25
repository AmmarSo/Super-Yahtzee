# yahtzee_app

Jeux de Yahtzee

## Règles du jeux

Objectif du jeu
Obtenir les meilleures combinaisons possibles pour maximiser le score en 13 tours.

Matériel
5 dés à 6 faces.
Une feuille de score avec différentes catégories (ou une application pour suivre le score).
Déroulement d'une partie
Tours de jeu :

Chaque joueur joue à tour de rôle.
À chaque tour, un joueur peut lancer les 5 dés jusqu'à 3 fois.
Après chaque lancer, le joueur peut choisir de "verrouiller" certains dés et relancer les autres.
À la fin de ses 3 lancers (ou avant, s'il le souhaite), il doit choisir une catégorie de score où inscrire le résultat.
Choix de la catégorie :

Une catégorie ne peut être utilisée qu'une seule fois par joueur. Si aucune combinaison ne correspond, le joueur doit inscrire un score de 0 dans une catégorie de son choix.
Fin de la partie :

Le jeu se termine lorsque chaque joueur a rempli les 13 catégories.
On additionne les points de chaque joueur pour déterminer le gagnant.
Feuille de score
Section supérieure : Combinaisons simples
Chaque combinaison correspond à la somme des dés montrant une face spécifique :

1 (Ones) : Somme des dés montrant des "1".
2 (Twos) : Somme des dés montrant des "2".
3 (Threes) : Somme des dés montrant des "3".
4 (Fours) : Somme des dés montrant des "4".
5 (Fives) : Somme des dés montrant des "5".
6 (Sixes) : Somme des dés montrant des "6".
Bonus : Si la somme des scores de cette section atteint ou dépasse 63 points, le joueur reçoit un bonus de 35 points.

Section inférieure : Combinaisons spéciales
Brelan (Three of a Kind) :

Au moins 3 dés identiques.
Score = somme totale des 5 dés.
Carré (Four of a Kind) :

Au moins 4 dés identiques.
Score = somme totale des 5 dés.
Full (Full House) :

Une combinaison de 3 dés identiques + 2 dés identiques.
Score = 25 points.
Petite suite (Small Straight) :

Une suite de 4 dés consécutifs (ex : 1-2-3-4 ou 3-4-5-6).
Score = 30 points.
Grande suite (Large Straight) :

Une suite de 5 dés consécutifs (ex : 1-2-3-4-5 ou 2-3-4-5-6).
Score = 40 points.
Yahtzee :

Les 5 dés montrent la même valeur.
Score = 50 points.
Bonus Yahtzee : Si un joueur réalise plusieurs Yahtzees, chaque Yahtzee supplémentaire rapporte 100 points.
Chance :

Somme totale des 5 dés, sans contrainte.

## Modes de jeux

- Solo
- Deux Joueurs

## Arborescence

lib/
│
├── main.dart               # Point d'entrée de l'application
├── screens/                # Écrans principaux
│   ├── game_mode_screen.dart  # Écran de sélection du mode de jeu
│   ├── game_screen.dart       # Écran principal du jeu
│   ├── score_screen.dart      # Écran pour afficher les scores
│
├── widgets/                # Widgets réutilisables
│   ├── dice_widget.dart       # Widget pour un dé interactif
│   ├── score_table.dart       # Widget pour le tableau de score
│   ├── player_card.dart       # Widget pour afficher les infos d'un joueur
│
├── models/                 # Modèles de données
│   ├── dice.dart              # Classe pour gérer un dé
│   ├── player.dart            # Classe pour représenter un joueur
│   ├── score_card.dart        # Classe pour gérer une feuille de score
│
├── providers/              # Gestion de l'état
│   ├── game_provider.dart      # Fournit l'état global du jeu (mode, tours, etc.)
│
├── utils/                  # Fonctions utilitaires
│   ├── score_utils.dart       # Fonctions pour calculer les combinaisons et scores
│
├── constants/              # Constantes et styles
│   ├── app_styles.dart        # Styles globaux (couleurs, tailles)
│   ├── app_texts.dart         # Textes fixes (ex. titres, règles)
│
