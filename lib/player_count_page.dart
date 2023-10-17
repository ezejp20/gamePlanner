import 'package:flutter/material.dart';
import 'player_names_page.dart';

class PlayerCountPage extends StatefulWidget {
  final int gameType;
  final int gameDuration;

  PlayerCountPage(this.gameType, this.gameDuration);

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
              'You have chosen ${widget.gameType}-a-side game.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Game duration: ${widget.gameDuration} minutes.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text('Enter the number of players:'),
            SizedBox(height: 10),
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
            if (errorMessage != null)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: () {
                if (playerCount != null) {
                  if (playerCount! < widget.gameType) {
                    setState(() {
                      errorMessage = "You don't have enough players!";
                    });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerNamesPage(
                            widget.gameType, widget.gameDuration, playerCount!),
                      ),
                    );
                  }
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