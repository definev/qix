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

  List<RectangleHitbox> hitBoxes = [];
  final _continueHitbox = RectangleHitbox();

  Paint linePaint = Paint()
    ..strokeWidth = 3
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  void addPoint(Vector2 point) {
    _points.add(point);
    if (_points.length >= 2) {
      final prevPoint = _points[_points.length - 2];
      final hitbox = createRectangleFromPoint(prevPoint, point);
      if (hitbox != null) {
        hitBoxes.add(hitbox);
        add(hitbox);
      }
    }
  }

  @override
  Future<void>? onLoad() async {
    add(ball);
    add(_continueHitbox);
  }

  @override
  void onMount() {
    super.onMount();
    ball.center = (ancestor.bottomLeft + ancestor.bottomRight) / 2;
  }

  @override
  void update(double dt) {
    if (_points.isNotEmpty) setCurrentHitBox(_points.last, ball.center);
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

  void setCurrentHitBox(Vector2 prevPoint, Vector2 point) {
    if (prevPoint.x == point.x) {
      if (prevPoint.y > point.y) {
        _continueHitbox.position = point;
        _continueHitbox.size = Vector2(1, prevPoint.y - point.y);
      } else {
        _continueHitbox.position = prevPoint;
        _continueHitbox.size = Vector2(1, point.y - prevPoint.y);
      }
    }

    if (prevPoint.y == point.y) {
      if (prevPoint.x > point.x) {
        _continueHitbox.position = point;
        _continueHitbox.size = Vector2(prevPoint.x - point.x, 1);
      } else {
        _continueHitbox.position = prevPoint;
        _continueHitbox.size = Vector2(point.x - prevPoint.x, 1);
      }
    }
  }

  RectangleHitbox? createRectangleFromPoint(Vector2 prevPoint, Vector2 point) {
    RectangleHitbox? hitbox;
    if (prevPoint.x == point.x) {
      if (prevPoint.y > point.y) {
        hitbox = RectangleHitbox(
          position: point,
          size: Vector2(1, prevPoint.y - point.y),
        );
      } else {
        hitbox = RectangleHitbox(
          position: prevPoint,
          size: Vector2(1, point.y - prevPoint.y),
        );
      }
    }

    if (prevPoint.y == point.y) {
      if (prevPoint.x > point.x) {
        hitbox = RectangleHitbox(
          position: point,
          size: Vector2(prevPoint.x - point.x, 1),
        );
      } else {
        hitbox = RectangleHitbox(
          position: prevPoint,
          size: Vector2(point.x - prevPoint.x, 1),
        );
      }
    }

    return hitbox;
  }
}
