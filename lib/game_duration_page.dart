import 'package:flutter/material.dart';
import 'player_count_page.dart'; // Make sure this import path is correct

class GameDurationPage extends StatefulWidget {
  final int? gameType;
  GameDurationPage(this.gameType);

  @override
  _GameDurationPageState createState() => _GameDurationPageState();
}

class _GameDurationPageState extends State<GameDurationPage> {
  int? gameDuration;
  int? segmentLength; // New variable for segment length

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Duration and Segment Length'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have chosen ${widget.gameType}-a-side game.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text('Enter game duration (minutes):'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  gameDuration = int.tryParse(value);
                },
                decoration: InputDecoration(
                  hintText: 'Enter game duration',
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
                'Enter segment length (minutes):'), // Prompt for segment length
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  segmentLength = int.tryParse(value);
                },
                decoration: InputDecoration(
                  hintText: 'Enter segment length',
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (gameDuration != null && segmentLength != null) {
                  // Ensure segmentLength is valid
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerCountPage(
                          widget.gameType!,
                          gameDuration!,
                          segmentLength!), // Pass segmentLength to the next page
                    ),
                  );
                } else {
                  // Ideally, show an error message if the input is invalid
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
