import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:qix/components/background/boundary.dart';
import 'package:qix/components/background/filled_area.dart';
import 'package:qix/components/player/components/ball_line.dart';
import 'package:universal_io/io.dart';

void main() {
  const game = Center(
    child: SizedBox(
      height: 400,
      width: 700,
      child: GameWidget.controlled(gameFactory: QixGame.new),
    ),
  );
  if (Platform.isMacOS) {
    runApp(
      Focus(
        onKey: (FocusNode node, RawKeyEvent event) => KeyEventResult.handled,
        child: game,
      ),
    );
  } else {
    runApp(game);
  }
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
