import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:qix/components/background/boundary.dart';
import 'package:qix/components/background/filled_area.dart';
import 'package:qix/components/player/collisions/ball_line.dart';
import 'package:qix/components/player/components/ball.dart';
import 'package:qix/components/utils/collision_between.dart';
import 'package:qix/components/utils/debug_color.dart';
import 'package:qix/components/utils/line_hit_box.dart';

class BallLine extends ShapeComponent //
    with
        HasGameReference,
        ParentIsA<FilledArea>,
        HasAncestor<Boundary>,
        CollisionCallbacks,
        ExactCollisionHandler<BallLine> {
  BallLine({super.children});

  late List<Vector2> points = [];
  late List<Offset> _rawPoints = [];
  late final ball = Ball();

  List<RectangleHitbox> _hitBoxes = [];
  var _latestLine = LineHitBox.create(from: Vector2.all(0), to: Vector2.all(0)) //
    ..debugColor = DebugColors.ballLine;

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
      _hitBoxes.add(hitbox..debugColor = DebugColors.ballLine);
      add(hitbox);
    }
  }

  void setCurrentHitBox(Vector2 prevPoint, Vector2 point) {
    if (point.distanceToSquared(prevPoint) < 4) return;
    const expand = 10;

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

  Future<RectangleHitbox?> createRectangleFromPoint(Vector2 prevPoint, Vector2 point) async => await Future.delayed(
        const Duration(milliseconds: 100),
        () {
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
        },
      );

  @override
  Paint get paint => Paint()
    ..color = Colors.white
    ..strokeWidth = 1;

  @override
  Future<void>? onLoad() async {
    add(ball);
    add(_latestLine);
  }

  @override
  void onMount() {
    super.onMount();
    ball.center = (ancestor.bottomLeft + ancestor.bottomRight) / 2;
    mountExactColliables({
      ball: BallLineNBallCollision(this, ball),
    });
  }

  @override
  void update(double dt) {
    if (points.isNotEmpty) setCurrentHitBox(points.last, ball.center);
  }

  @override
  void render(Canvas canvas) {
    final allPoints = [..._rawPoints];
    if (points.isNotEmpty) allPoints.add(ball.center.toOffset());
    if (allPoints.isEmpty) return;

    canvas.drawPoints(PointMode.polygon, allPoints, paint);
  }

  void resetLine() {
    for (var hitBox in _hitBoxes) {
      remove(hitBox);
    }
    remove(_latestLine);
    _latestLine = LineHitBox.create(from: Vector2.all(0), to: Vector2.all(0)) //
      ..debugColor = DebugColors.ballLine;
    add(_latestLine);
    _hitBoxes = [];
    points = [];
    _rawPoints = [];
  }
}
