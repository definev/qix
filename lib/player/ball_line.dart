import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BallLine extends ShapeComponent with HasGameReference {
  BallLine({super.children});

  late List<Vector2> _points = [];
  late final ball = Ball(position: game.size / 2);

  Paint linePaint = Paint()
    ..strokeWidth = 3
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  final path = Path()..fillType = PathFillType.nonZero;

  void addPoint(Vector2 point) {
    final offset = point.toOffset();
    path.lineTo(offset.dx, offset.dy);
  }

  @override
  Future<void>? onLoad() {
    add(ball);
    _points = [ball.center];

    final last = _points.last.toOffset();
    final center = ball.center.toOffset();
    path //
      ..moveTo(last.dx, last.dy)
      ..lineTo(center.dx, center.dy);

    return null;
  }

  @override
  void render(Canvas canvas) {
    final center = ball.center.toOffset();
    canvas.drawPaint(
      Paint()
        ..shader = const LinearGradient(
          colors: [Colors.white, Colors.black26],
        ).createShader(Rect.fromLTRB(0, 0, size.x, size.y)),
    );
    canvas.drawPath(
      Path.from(path) //
        ..lineTo(center.dx, center.dy),
      paint,
    );
  }
}

class Ball extends CircleComponent with KeyboardHandler, ParentIsA<BallLine> {
  Ball({
    super.radius = 10,
    super.position,
  });

  @override
  Paint get paint => Paint()..color = Colors.red;

  AxisDirection? direction;

  @override
  void update(double dt) {
    final dist = 60 * dt;
    final current = position.clone();

    switch (direction) {
      case null:
        break;
      case AxisDirection.up:
        position = current + Vector2(0, -dist);
        break;
      case AxisDirection.down:
        position = current + Vector2(0, dist);
        break;
      case AxisDirection.left:
        position = current + Vector2(-dist, 0);
        break;
      case AxisDirection.right:
        position = current + Vector2(dist, 0);
        break;
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event.repeat) return true;
    if (keysPressed.length == 1) {
      final key = keysPressed.first;
      final prevDirection = direction;

      if (key == LogicalKeyboardKey.arrowLeft &&
          prevDirection != AxisDirection.left &&
          prevDirection != AxisDirection.right) direction = AxisDirection.left;
      if (key == LogicalKeyboardKey.arrowRight &&
          prevDirection != AxisDirection.left &&
          prevDirection != AxisDirection.right) direction = AxisDirection.right;
      if (key == LogicalKeyboardKey.arrowUp && //
          prevDirection != AxisDirection.up &&
          prevDirection != AxisDirection.down) direction = AxisDirection.up;
      if (key == LogicalKeyboardKey.arrowDown &&
          prevDirection != AxisDirection.up &&
          prevDirection != AxisDirection.down) direction = AxisDirection.down;

      if (prevDirection != direction) {
        parent.addPoint(center.clone());
      }
    }

    return true;
  }
}
