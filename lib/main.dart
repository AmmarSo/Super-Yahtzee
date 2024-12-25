import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/game_mode_screen.dart';
import 'screens/game_screen.dart';
import 'models/game_settings.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yahtzee',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>  GameModeScreen(),
        '/game': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as GameSettings;
          return GameScreen(mode: args.mode); // Correction du paramètre 'mode'
        },
      },
    );
  }
}
