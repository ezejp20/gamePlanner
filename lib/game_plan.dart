import 'package:flutter/material.dart';
import 'player_names_page.dart'; // Make sure this import is correct based on your project structure
import 'game_start_page.dart';

class GamePlanPage extends StatelessWidget {
  final int gameType;
  final int gameDuration;
  final int segmentLength; // New parameter for segment length
  final List<PlayerData> players;

  GamePlanPage(
      this.gameType, this.gameDuration, this.players, this.segmentLength);

  int get numSegments => (gameDuration / segmentLength).ceil();

  List<String> generateSubstitutionMessages() {
    List<String> substitutions = [];
    List<List<PlayerData>> allSegmentsPlayers =
        List.generate(numSegments, (_) => []);
    // Generate players for each segment
    for (int i = 0; i < numSegments; i++) {
      allSegmentsPlayers[i] = calculatePlayersForSegment(i);
    }
    // Create substitution messages
    for (int i = 1; i < allSegmentsPlayers.length; i++) {
      List<PlayerData> prevSegment = allSegmentsPlayers[i - 1];
      List<PlayerData> currentSegment = allSegmentsPlayers[i];
      List<PlayerData> comingOn =
          currentSegment.where((p) => !prevSegment.contains(p)).toList();
      List<PlayerData> goingOff =
          prevSegment.where((p) => !currentSegment.contains(p)).toList();

      String message = "Segment ${i}: ";
      if (goingOff.isNotEmpty) {
        String goingOffNames = goingOff.map((p) => p.name).join(", ");
        message += "$goingOffNames off; ";
      }
      if (comingOn.isNotEmpty) {
        String comingOnNames = comingOn
            .map((p) => "${p.name} (${p.positions.join('/')})")
            .join(", ");
        message += "$comingOnNames on";
      }
      substitutions.add(message);
    }
    return substitutions;
  }

  List<PlayerData> calculatePlayersForSegment(int segmentNumber) {
    List<PlayerData> onPitchPlayers = [];
    List<PlayerData> inGoalPlayers = [];
    List<PlayerData> offPitchPlayers = [];

    List<PlayerData> willingGoalies =
        players.where((player) => player.isWillingToGoInGoal).toList();
    int goaliesIndex = segmentNumber % willingGoalies.length;
    inGoalPlayers = [willingGoalies[goaliesIndex]];

    List<PlayerData> outfieldPlayers =
        players.where((player) => !inGoalPlayers.contains(player)).toList();
    int playersOnPitch = gameType - 1;
    int outfieldStartIndex = segmentNumber % outfieldPlayers.length;
    for (int i = 0; i < playersOnPitch; i++) {
      int index = (outfieldStartIndex + i) % outfieldPlayers.length;
      onPitchPlayers.add(outfieldPlayers[index]);
    }

    offPitchPlayers = players
        .where((player) =>
            !onPitchPlayers.contains(player) && !inGoalPlayers.contains(player))
        .toList();

    // Assign roles (this part can be adjusted based on your actual logic)
    onPitchPlayers.forEach((player) => player.role = 'onPitch');
    inGoalPlayers.forEach((player) => player.role = 'inGoal');
    offPitchPlayers.forEach((player) => player.role = 'offPitch');

    return [...onPitchPlayers, ...inGoalPlayers, ...offPitchPlayers];
  }

  @override
  Widget build(BuildContext context) {
    List<String> substitutions = generateSubstitutionMessages();
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Plan'),
      ),
      body: ListView.builder(
        itemCount: numSegments,
        itemBuilder: (context, index) {
          final int startTime = index * segmentLength;
          int endTime = startTime + segmentLength;
          if (index == numSegments - 1 && gameDuration % segmentLength != 0) {
            endTime = gameDuration;
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameStartPage(
                gameDuration: gameDuration,
                segmentLength: segmentLength,
                substitutions: substitutions,
              ),
            ),
          );
        },
        child: Icon(Icons.play_arrow),
        backgroundColor: Colors.green,
      ),
    );
  }

  String getPlayersByRole(List<PlayerData> players, String role) {
    List<PlayerData> filteredPlayers =
        players.where((player) => player.role == role).toList();
    String positionMessage = '';
    if (role == 'onPitch') {
      final missingPositions = ['Defence', 'Mid', 'Forward']
          .where((position) => filteredPlayers
              .every((player) => !player.positions.contains(position)))
          .toList();
      if (missingPositions.isNotEmpty) {
        positionMessage =
            'Someone will have to play out of position to cover ${missingPositions.join('/')}.';
      }
      return filteredPlayers
              .map((player) =>
                  '${player.name} (${player.positions.where((position) => position != 'Goal').join('/')})')
              .join(', ') +
          (positionMessage.isNotEmpty ? " $positionMessage" : "");
    } else {
      return filteredPlayers.map((player) => player.name).join(', ');
    }
  }
}
