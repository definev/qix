import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:qix/components/background/boundary.dart';
import 'package:qix/components/background/filled_area.dart';
import 'package:qix/components/player/ball_line.dart';

void main() {
  runApp(
    const Center(
      child: SizedBox(
        height: 400,
        width: 400,
        child: GameWidget.controlled(gameFactory: QixGame.new),
      ),
    ),
  );
}

class QixGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  @override
  bool get debugMode => false;

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
