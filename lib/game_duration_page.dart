import 'package:flutter/material.dart';
import 'player_count_page.dart';
class GameDurationPage extends StatefulWidget {
  final int? gameType;
  GameDurationPage(this.gameType);
  @override
  _GameDurationPageState createState() => _GameDurationPageState();
}

class _GameDurationPageState extends State<GameDurationPage> {
  int? gameType;
  int? gameDuration;

  @override
  void initState() {
    super.initState();
    gameType = widget.gameType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Duration'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have chosen $gameType-a-side game.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text('Enter game duration (minutes):'),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    gameDuration = int.tryParse(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter game duration',
                                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (gameDuration != null) { // Check if gameDuration has been set
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerCountPage(widget.gameType!, gameDuration!),
                    ),
                  );
                } else {
                  // Display an error message or prevent navigation without selecting game duration.
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}