import 'package:flutter/material.dart';
import 'dart:async';

// Assuming PlayerData structure is defined somewhere, like player_names_page.dart
import 'player_names_page.dart';

class GameStartPage extends StatefulWidget {
  final int gameDuration;
  final int segmentLength;
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
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        _elapsedSeconds++;
        // Check if it's time to move to the next segment
        if (_elapsedSeconds % (widget.segmentLength * 60) == 0) {
          // Move to the next segment
          _currentSegment++;
          // If all segments have been completed, cancel the timer
          if (_currentSegment >= widget.substitutions.length) {
            _timer?.cancel();
            _showGameEndAlert();
          } else {
            _showSubstitutionAlert();
          }
        }
      });
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
                  Navigator.of(context).pop();
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
              onPressed: () => Navigator.of(context).pop(),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Game In Progress'),
      ),
      body: Center(
        child: Text(
            'Segment ${_currentSegment + 1} of ${widget.substitutions.length}'),
      ),
    );
  }
}
