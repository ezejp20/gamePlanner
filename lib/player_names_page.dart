import 'package:flutter/material.dart';
import 'game_plan.dart';
class PlayerData {
  String? name;
  String role;
  bool isWillingToGoInGoal;
  PlayerData({this.name = '', this.isWillingToGoInGoal=false, this.role = ''});
}

class PlayerNamesPage extends StatefulWidget {
  final int gameType;
  final int gameDuration;
  final int playerCount;

  PlayerNamesPage(this.gameType, this.gameDuration, this.playerCount);

  @override
  _PlayerNamesPageState createState() => _PlayerNamesPageState();
}

class _PlayerNamesPageState extends State<PlayerNamesPage> {
  List<PlayerData> players = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.playerCount; i++) {
      players.add(PlayerData(name: 'Player ${i + 1}'));
    }
  }

  // Define _navigateToGamePlanPage within _PlayerNamesPageState
  void _navigateToGamePlanPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePlanPage(
          widget.gameType,
          widget.gameDuration,
          players,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Names and Goalies'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Happy to go in goal?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          onChanged: (value) {
                            players[index].name = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Player ${index + 1}',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Checkbox(
                          value: players[index].isWillingToGoInGoal,
                          onChanged: (value) {
                            setState(() {
                              players[index].isWillingToGoInGoal = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Add a "Next" button
          ElevatedButton(
            onPressed: _navigateToGamePlanPage,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}