import 'package:flutter/material.dart';
import 'player_names_page.dart';

class GamePlanPage extends StatelessWidget {
  final int gameType;
  final int gameDuration;
  final List<PlayerData> players;

  List<PlayerData> rotatedPlayers = [];
  List<PlayerData> rotatedGoalies = [];

  GamePlanPage(this.gameType, this.gameDuration, this.players) {
    // Initialize the rotatedPlayers list with a copy of the players list
    rotatedPlayers = List.from(players);
    // Initialize the rotatedGoalies list with a copy of the goalies list
    rotatedGoalies = List.from(players.where((player) => player.isWillingToGoInGoal).toList());
  }

  List<PlayerData> onPitchPlayers = [];
  List<PlayerData> inGoalPlayers = [];
  List<PlayerData> offPitchPlayers = [];

List<PlayerData> calculatePlayersForSegment(int segmentNumber) {
  onPitchPlayers.clear();
  inGoalPlayers.clear();
  offPitchPlayers.clear();

  // Filter players who are willing to go in goal
  List<PlayerData> willingGoalies = players.where((player) => player.isWillingToGoInGoal).toList();

  // Rotate goalies who are willing to go in goal
  int goaliesIndex = segmentNumber % willingGoalies.length;
  inGoalPlayers = [willingGoalies[goaliesIndex]];

  // Create a list of outfield players, including those willing to go in goal
  List<PlayerData> outfieldPlayers = players.where((player) => !inGoalPlayers.contains(player)).toList();

  // Calculate the range of outfield players for this segment
  int playersOnPitch = gameType - 1;
 // Calculate the outfield players for this segment
int outfieldStartIndex = segmentNumber % outfieldPlayers.length;
List<PlayerData> outfieldPlayersForSegment = [];

for (int i = 0; i < playersOnPitch; i++) {
  int index = (outfieldStartIndex + i) % outfieldPlayers.length;
  outfieldPlayersForSegment.add(outfieldPlayers[index]);
}

  // Calculate the list of players substituted off
  offPitchPlayers = players.where((player) => !inGoalPlayers.contains(player) && !outfieldPlayersForSegment.contains(player)).toList();

  // Assign the role for each player
  outfieldPlayersForSegment.forEach((player) {
    player.role = 'onPitch';
  });
  inGoalPlayers.forEach((player) {
    player.role = 'inGoal';
  });
  offPitchPlayers.forEach((player) {
    player.role = 'offPitch';
  });

  // Combine the lists for this segment
  List<PlayerData> segmentPlayers = [];
  segmentPlayers.addAll(outfieldPlayersForSegment);
  segmentPlayers.addAll(inGoalPlayers);
  segmentPlayers.addAll(offPitchPlayers);

  return segmentPlayers;
}


  String getPlayersByRole(List<PlayerData> players, String role) {
    List<PlayerData> filteredPlayers = players.where((player) => player.role == role).toList();
    return filteredPlayers.map((player) => player.name).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final int segmentLength = 5;
    int numSegments = (segmentLength > 0 && gameDuration >= segmentLength) ? (gameDuration / segmentLength).ceil() : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Game Plan'),
      ),
      body: ListView.builder(
        itemCount: numSegments,
        itemBuilder: (context, index) {
          final int startTime = index * segmentLength;
          final int endTime = startTime + segmentLength;

          final List<PlayerData> segmentPlayers = calculatePlayersForSegment(index);

          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('Segment ${index + 1} ($startTime-$endTime mins)'),
                ),
                ListTile(
                  title: Text('Players on the Pitch:'),
                  subtitle: Text(getPlayersByRole(segmentPlayers, 'onPitch')),
                ),
                ListTile(
                  title: Text('Player in Goal:'),
                  subtitle: Text(getPlayersByRole(segmentPlayers, 'inGoal')),
                ),
                ListTile(
                  title: Text('Players Off the Pitch:'),
                  subtitle: Text(getPlayersByRole(segmentPlayers, 'offPitch')),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}