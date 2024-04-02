import 'package:flutter/material.dart';
import 'player_names_page.dart';

class GamePlanPage extends StatelessWidget {
  final int gameType;
  final int gameDuration;
  final int segmentLength; // New parameter for segment length
  final List<PlayerData> players;

  GamePlanPage(
      this.gameType, this.gameDuration, this.players, this.segmentLength);

  int get numSegments => (gameDuration / segmentLength)
      .ceil(); // Updated to calculate number of segments correctly

  List<PlayerData> onPitchPlayers = [];
  List<PlayerData> inGoalPlayers = [];
  List<PlayerData> offPitchPlayers = [];

  List<PlayerData> calculatePlayersForSegment(int segmentNumber) {
    onPitchPlayers.clear();
    inGoalPlayers.clear();
    offPitchPlayers.clear();

    // Filter players who are willing to go in goal
    List<PlayerData> willingGoalies =
        players.where((player) => player.isWillingToGoInGoal).toList();

    // Rotate goalies who are willing to go in goal
    int goaliesIndex = segmentNumber % willingGoalies.length;
    inGoalPlayers = [willingGoalies[goaliesIndex]];

    // Create a list of outfield players, including those willing to go in goal
    List<PlayerData> outfieldPlayers =
        players.where((player) => !inGoalPlayers.contains(player)).toList();

    // Calculate the range of outfield players for this segment
    int playersOnPitch = gameType - 1;
    int outfieldStartIndex = segmentNumber % outfieldPlayers.length;
    List<PlayerData> outfieldPlayersForSegment = [];

    for (int i = 0; i < playersOnPitch; i++) {
      int index = (outfieldStartIndex + i) % outfieldPlayers.length;
      outfieldPlayersForSegment.add(outfieldPlayers[index]);
    }

    // Calculate the list of players substituted off
    offPitchPlayers = players
        .where((player) =>
            !inGoalPlayers.contains(player) &&
            !outfieldPlayersForSegment.contains(player))
        .toList();

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
    List<PlayerData> filteredPlayers =
        players.where((player) => player.role == role).toList();

    if (role == 'onPitch') {
      // Check if there are players without the necessary positions
      final missingPositions = ['Defence', 'Mid', 'Forward']
          .where((position) => filteredPlayers
              .every((player) => !player.positions.contains(position)))
          .toList();

      String positionMessage = '';
      if (missingPositions.isNotEmpty) {
        // Someone will have to play out of position to cover missing positions
        positionMessage =
            'Someone will have to play out of position to cover ${missingPositions.join('/')}.';
      }

      return filteredPlayers.map((player) {
        // Display positions for "Players on the Pitch" without "Goal"
        final positions =
            player.positions.where((position) => position != 'Goal');
        return '${player.name} (${positions.join('/')})';
      }).followedBy([positionMessage]).join(', '); // Add the message
    } else {
      // Do not display positions for "Player in Goal" or "Players Off the Pitch"
      return filteredPlayers.map((player) => player.name).join(', ');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use numSegments here to determine the itemCount for ListView.builder
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Plan'),
      ),
      body: ListView.builder(
        itemCount:
            numSegments, // Updated to use the calculated number of segments
        itemBuilder: (context, index) {
          final int startTime = index * segmentLength;
          int endTime = startTime + segmentLength;
          if (index == numSegments - 1 && gameDuration % segmentLength != 0) {
            // Check for the last segment
            endTime =
                gameDuration; // Adjust the end time for the last segment if needed
          }

          final List<PlayerData> segmentPlayers =
              calculatePlayersForSegment(index);

          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title:
                      Text('Segment ${index + 1} ($startTime-$endTime mins)'),
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
