import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:qix/components/background/boundary.dart';
import 'package:qix/components/player/ball.dart';

class BallLine extends ShapeComponent with HasGameReference, HasAncestor<Boundary> {
  BallLine({super.children});

  late final List<Vector2> _points = [];
  late final ball = Ball();

  Paint linePaint = Paint()
    ..strokeWidth = 3
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  void addPoint(Vector2 point) {
    _points.add(point);
    if (_points.length >= 2) {
      add(RectangleHitbox());
    }
  }

  @override
  Future<void>? onLoad() async {
    add(ball);
  }

  @override
  void onMount() {
    super.onMount();
    ball.center = (ancestor.bottomLeft + ancestor.bottomRight) / 2;
  }

  @override
  void render(Canvas canvas) {
    for (var index = 0; index < _points.length - 1; index++) {
      final p1 = _points[index].toOffset();
      final p2 = _points[index + 1].toOffset();
      canvas.drawLine(p1, p2, linePaint);
    }

    if (_points.isNotEmpty) {
      final p1 = _points.last.toOffset();
      final p2 = ball.center.toOffset();
      canvas.drawLine(p1, p2, linePaint);
    }
  }
}
