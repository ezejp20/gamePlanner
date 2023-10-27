import 'package:flutter/material.dart';
import 'game_plan.dart';

class PlayerData {
  String? name;
  String role;
  bool isWillingToGoInGoal;
  List<String> positions = []; // Initialize as an empty list
  PlayerData({this.name = '', this.isWillingToGoInGoal = false, this.role = ''});
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Player ${index + 1}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (value) {
                          players[index].name = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Name',
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: players[index].positions.contains('Goal'),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                players[index].positions.add('Goal');
                                players[index].isWillingToGoInGoal = true; // Set to true when "Goal" is selected
                              } else {
                                players[index].positions.remove('Goal');
                                if (players[index].positions.isEmpty) {
                                  players[index].isWillingToGoInGoal = false; // Set to false if no positions are selected
                                }
                              }
                            });
                          },
                        ),
                        Text('Goal'),
                        Checkbox(
                          value: players[index].positions.contains('Defence'),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                players[index].positions.add('Defence');
                              } else {
                                players[index].positions.remove('Defence');
                              }
                            });
                          },
                        ),
                        Text('Defence'),
                        Checkbox(
                          value: players[index].positions.contains('Mid'),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                players[index].positions.add('Mid');
                              } else {
                                players[index].positions.remove('Mid');
                              }
                            });
                          },
                        ),
                        Text('Mid'),
                        Checkbox(
                          value: players[index].positions.contains('Forward'),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                players[index].positions.add('Forward');
                              } else {
                                players[index].positions.remove('Forward');
                              }
                            });
                          },
                        ),
                        Text('Forward'),
                      ],
                    ),
                    // Repeat the above code for Defence, Midfield, and Forward positions
                  ],
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _navigateToGamePlanPage,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}
