import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';

import 'helpers/direction.dart';

class SequenceEffectExample extends FlameGame
    with HasKeyboardHandlerComponents, HasDraggables {
  static const String description = '''
    Sequence of effects, consisting of a move effect, a rotate effect, another
    move effect, a scale effect, and then one more move effect. The sequence
    then runs in the opposite order (alternate = true) and loops infinitely
    (infinite = true).
  ''';

  late Player player = Player()..position = size / 2;

  void onDirectionChange(Direction direction) {
    if (player.lastDirection == direction.opposite) {
      player.direction = Direction.none;
      return;
    }
    player.direction = direction;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(player);
  }
}

class Player extends PositionComponent with KeyboardHandler, HasGameRef {
  Player() : super(anchor: Anchor.center, size: Vector2(20, 20), priority: 0);

  late Path path;
  late Paint bodyPaint;
  final Paint _directionPaint = Paint()
    ..strokeWidth = 3
    ..color = const Color(0xFFFFFFFF)
    ..style = PaintingStyle.stroke;

  final double _speed = 1;

  Direction direction = Direction.none;
  Direction lastDirection = Direction.none;

  List<Tuple2<Direction, double>> _directionPath = [];
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
      _directionPath.add(Tuple2(direction, 0));
    }
    switch (direction) {
      case Direction.none:
        break;
      default:
        lastDirection = direction;
        _directionPath.last = _directionPath.last.copyWith(
          value2: _directionPath.last.second + _speed,
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
    for (final direction in _directionPath.reversed) {
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

  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyDownEvent) {
      if (direction != lastDirection.opposite) {
        direction = Direction.none;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        direction = Direction.up;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        direction = Direction.down;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        direction = Direction.left;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        direction = Direction.right;
      } else {
        direction = Direction.none;
      }
    }

    return true;
  }
}
