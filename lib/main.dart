import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'helpers/joypad.dart';
import 'wix_game.dart';

void main() {
  final game = SequenceEffectExample();
  runApp(
    MaterialApp(
      color: Colors.blue,
      home: Stack(
        children: [
          GameWidget(game: game),
          Align(
            alignment: Alignment.bottomRight,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Joypad(onDirectionChanged: game.onDirectionChange),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
