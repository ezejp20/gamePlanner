import 'package:flutter/material.dart';

class GameStartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Start'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Start the game and manage the timer
            // Implement timer management and player substitutions here
            // Example: Navigator.pop(context);
          },
          child: Text('Start Game'),
        ),
      ),
    );
  }
}
