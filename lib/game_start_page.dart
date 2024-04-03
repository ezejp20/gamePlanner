import 'package:flutter/material.dart';
import 'dart:async';

// Assuming PlayerData structure is defined somewhere, like player_names_page.dart
import 'player_names_page.dart';

class GameStartPage extends StatefulWidget {
  final int gameDuration;
  final int segmentLength; // Segment length in minutes
  final List<String> substitutions; // Substitution messages for each segment

  GameStartPage({
    Key? key,
    required this.gameDuration,
    required this.segmentLength,
    required this.substitutions,
  }) : super(key: key);

  @override
  _GameStartPageState createState() => _GameStartPageState();
}

class _GameStartPageState extends State<GameStartPage> {
  Timer? _timer;
  int _currentSegment = 0;
  int _segmentEndTime =
      0; // The time (in seconds) when the current segment ends

  @override
  void initState() {
    super.initState();
    _segmentEndTime = widget.segmentLength * 60; // Initialize segment end time
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_segmentEndTime == 0) {
        // Segment has ended
        _showSubstitutionAlert();
        _currentSegment++;
        if (_currentSegment >= widget.substitutions.length) {
          // All segments completed
          _timer?.cancel();
          _showGameEndAlert();
        } else {
          // Start next segment
          _segmentEndTime = widget.segmentLength * 60;
        }
      } else {
        // Countdown
        setState(() {
          _segmentEndTime--;
        });
      }
    });
  }

  void _showSubstitutionAlert() {
    if (_currentSegment < widget.substitutions.length) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Substitution Alert"),
            content: Text(widget.substitutions[_currentSegment]),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _showGameEndAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("The game has ended."),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutesLeft = _segmentEndTime ~/ 60;
    int secondsLeft = _segmentEndTime % 60;
    return Scaffold(
      appBar: AppBar(
        title: Text('Game In Progress'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Segment ${_currentSegment + 1} of ${widget.substitutions.length}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'Time left: ${minutesLeft.toString().padLeft(2, '0')}:${secondsLeft.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
