import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:qix/components/background/boundary.dart';
import 'package:qix/components/background/filled_area.dart';
import 'package:qix/components/player/ball.dart';

class BallLine extends ShapeComponent //
    with
        HasGameReference,
        ParentIsA<FilledArea>,
        HasAncestor<Boundary>,
        CollisionCallbacks {
  BallLine({super.children});

  late List<Vector2> points = [];
  late List<Offset> _rawPoints = [];
  late final ball = Ball();

  List<RectangleHitbox> _hitBoxes = [];
  final _latestLine = RectangleHitbox();

  Paint linePaint = Paint()
    ..strokeWidth = 3
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  void addPoint(Vector2 point) async {
    points.add(point);
    _rawPoints.add(point.toOffset());
    if (points.length >= 2) {
      final prevPoint = points[points.length - 2];
      final hitbox = await createRectangleFromPoint(prevPoint, point);
      if (hitbox == null) return;
      _hitBoxes.add(hitbox);
      add(hitbox);
    }
  }

  void setCurrentHitBox(Vector2 prevPoint, Vector2 point) {
    if (point.distanceToSquared(prevPoint) < 4) return;
    const expand = 8;

    if (prevPoint.x == point.x) {
      if (prevPoint.y > point.y) {
        _latestLine.position = Vector2(point.x, point.y + expand);
      } else {
        _latestLine.position = prevPoint;
      }
      _latestLine.size = Vector2(1, max((point.y - prevPoint.y).abs() - expand, 0));
    }

    if (prevPoint.y == point.y) {
      if (prevPoint.x > point.x) {
        _latestLine.position = Vector2(point.x + expand, point.y);
      } else {
        _latestLine.position = prevPoint;
      }
      _latestLine.size = Vector2(max((prevPoint.x - point.x).abs() - expand, 0), 1);
    }
  }

  Future<RectangleHitbox?> createRectangleFromPoint(Vector2 prevPoint, Vector2 point) async {
    return await Future.delayed(const Duration(milliseconds: 100), () {
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
    });
  }

  @override
  // TODO: implement paint
  Paint get paint => Paint()
    ..color = Colors.white
    ..strokeWidth = 2;

  @override
  Future<void>? onLoad() async {
    add(ball);
    add(_latestLine);
  }

  @override
  void onMount() {
    super.onMount();
    ball.center = (ancestor.bottomLeft + ancestor.bottomRight) / 2;
  }

  @override
  void update(double dt) {
    if (points.isNotEmpty) setCurrentHitBox(points.last, ball.center);
  }

  @override
  void render(Canvas canvas) {
    final allPoints = [..._rawPoints];
    if (points.isNotEmpty) allPoints.add(ball.center.toOffset());

    canvas.drawPoints(
      PointMode.polygon,
      allPoints,
      paint,
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other == ball) {
      if (!ball.collidingWith(ancestor)) {
        ball.stop();
      }
    }
  }

  void resetLine() {
    _hitBoxes = [];
    points = [];
    _rawPoints = [];
  }
}
