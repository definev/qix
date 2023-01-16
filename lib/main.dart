import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:qix/components/background/boundary.dart';
import 'package:qix/components/background/filled_area.dart';
import 'package:qix/components/player/components/ball_line.dart';
import 'package:universal_io/io.dart';

void main() {
  const game = QixGameWidget();
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

class QixGameWidget extends StatefulWidget {
  const QixGameWidget({super.key});

  @override
  State<QixGameWidget> createState() => _QixGameWidgetState();
}

class _QixGameWidgetState extends State<QixGameWidget> {
  final game = QixGame(false);

  bool debugMode = false;

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: QixGame(debugMode),
      overlayBuilderMap: {
        'debug': (context, QixGame game) {
          return Material(
            child: Switch(
              value: debugMode,
              onChanged: (value) {
                game.debugMode = value;
                debugMode = value;
                setState(() {});
              },
            ),
          );
        },
      },
      initialActiveOverlays: const ['debug'],
    );
  }
}

class QixGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  QixGame(bool debugMode) {
    this.debugMode = debugMode;
  }

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
