import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:qix/components/background/boundary.dart';
import 'package:qix/components/background/filled_area.dart';
import 'package:qix/components/player/ball_line.dart';

void main() {
  runApp(const GameWidget.controlled(gameFactory: QixGame.new));
}

class QixGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  @override
  bool get debugMode => true;

  @override
  Future<void>? onLoad() async {
    add(Boundary(
      children: [
        FilledArea(
          children: [
            BallLine(),
          ],
        ),
      ],
    ));
  }
}
