import 'package:flutter/material.dart';
import 'player_names_page.dart'; // Ensure this import matches the path to your PlayerNamesPage

class PlayerCountPage extends StatefulWidget {
  final int gameType;
  final int gameDuration;
  final int segmentLength; // New parameter for segment length

  PlayerCountPage(this.gameType, this.gameDuration, this.segmentLength);

  @override
  _PlayerCountPageState createState() => _PlayerCountPageState();
}

class _PlayerCountPageState extends State<PlayerCountPage> {
  int? playerCount;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Count'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have chosen ${widget.gameType}-a-side game for ${widget.gameDuration} minutes.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Segment length: ${widget.segmentLength} minutes.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text('Enter the number of players:'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    playerCount = int.tryParse(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter player count',
                ),
              ),
            ),
            SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: () {
                if (playerCount != null && playerCount! >= widget.gameType) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerNamesPage(
                          widget.gameType,
                          widget.gameDuration,
                          playerCount!,
                          widget
                              .segmentLength), // Pass segmentLength to the next page
                    ),
                  );
                } else {
                  setState(() {
                    errorMessage = "Please enter a valid number of players.";
                  });
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
