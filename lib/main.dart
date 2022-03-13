import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'helpers/joypad.dart';
import 'wix_game.dart';

void main() {
  final game = QixGame();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.black,
      home: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.black),
        child: Stack(
          children: [
            GameWidget(game: game),
            Align(
              alignment: Alignment.bottomRight,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Joypad(onDirectionChanged: game.onDirectionChange),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
