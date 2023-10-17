import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'game_duration_page.dart';
import 'player_names_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameTypeSelection(),
    );
  }
}

class GameTypeSelection extends StatefulWidget {
  @override
  _GameTypeSelectionState createState() => _GameTypeSelectionState();
}

class _GameTypeSelectionState extends State<GameTypeSelection> {
  int? gameType; // Initialize to null

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Type Selection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    gameType = 5;
                  });
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameDurationPage(gameType)),
                  );
                },
                child: Text('5-a-side'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    gameType = 7;
                  });
                 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameDurationPage(gameType)),
                  );
                },
                child: Text('7-a-side'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    gameType = 11;
                  });
                 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameDurationPage(gameType)),
                  );
                },
                child: Text('11-a-side'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}