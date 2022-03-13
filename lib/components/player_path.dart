import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:fpdart/fpdart.dart';

import '../helpers/direction.dart';

class PlayerPath extends PositionComponent //
    with
        HasGameRef,
        HasHitboxes,
        Collidable {
  PlayerPath()
      : super(anchor: Anchor.center, size: Vector2(20, 20), priority: 0);

  late Path path;
  late Paint bodyPaint;
  final Paint _directionPaint = Paint()
    ..strokeWidth = 4
    ..color = const Color(0xFFFFFFFF)
    ..style = PaintingStyle.stroke;

  double _speed = 1;

  var direction = Direction.none;
  var lastDirection = Direction.none;

  final List<Tuple2<Direction, double>> directionPath = [];

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    final minSize = min(gameSize.x, gameSize.y);
    if (minSize < 400) {
      _speed = minSize / 400;
    } else {
      _speed = 1;
    }
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    path = Path()
      ..addOval(const Rect.fromLTRB(0, 0, 20, 20))
      ..close();
    bodyPaint = Paint()..color = const Color(0xFFFFB20D);
  }

  @override
  void update(double dt) {
    if (lastDirection != direction && direction != Direction.none) {
      directionPath.add(Tuple2(direction, 0));
    }
    switch (direction) {
      case Direction.none:
        break;
      default:
        lastDirection = direction;
        directionPath.last = directionPath.last.copyWith(
          value2: directionPath.last.second + _speed,
        );
    }
    switch (direction) {
      case Direction.up:
        position += Vector2(0, -_speed);
        break;
      case Direction.down:
        position += Vector2(0, _speed);
        break;
      case Direction.left:
        position += Vector2(-_speed, 0);
        break;
      case Direction.right:
        position += Vector2(_speed, 0);
        break;
      default:
        break;
    }
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawPath(path, bodyPaint);

    final renderDirectionPath = Path()..moveTo(10, 10);
    for (final direction in directionPath.reversed) {
      switch (direction.first) {
        case Direction.down:
          renderDirectionPath.relativeLineTo(0, -direction.second);
          break;
        case Direction.up:
          renderDirectionPath.relativeLineTo(0, direction.second);
          break;
        case Direction.left:
          renderDirectionPath.relativeLineTo(direction.second, 0);
          break;
        case Direction.right:
          renderDirectionPath.relativeLineTo(-direction.second, 0);
          break;
        default:
      }
    }
    canvas.drawPath(
      renderDirectionPath,
      _directionPaint,
    );
  }
}
