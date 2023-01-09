import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:qix/player/ball_line.dart';

void main() {
  runApp(const GameWidget.controlled(gameFactory: QixGame.new));
}

class QixGame extends FlameGame with HasKeyboardHandlerComponents {
  @override
  bool get debugMode => true;

  @override
  Future<void>? onLoad() async {
    add(BallLine());
  }
}
