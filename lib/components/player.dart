import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';

import '../helpers/direction.dart';
import '../qix_game.dart';
import 'boundary/boundary.dart';

enum OnBoundary {
  none,
  left,
  right,
  top,
  bottom,
}

class Player extends PositionComponent //
    with
        HasGameRef<QixGame>,
        KeyboardHandler,
        HasHitboxes,
        Collidable {
  Player() : super(anchor: Anchor.center, size: Vector2(20, 20), priority: 0);

  late Path path;
  late Paint bodyPaint;
  final Paint _directionPaint = Paint()
    ..strokeWidth = 3
    ..color = const Color(0xFFFFFFFF)
    ..style = PaintingStyle.stroke;

  // Percent of the screen that the player can move
  final double _speed = 0.005;

  var direction = Direction.none;
  var lastDirection = Direction.none;
  var onBoundary = OnBoundary.bottom;

  final List<Tuple2<Direction, double>> _directionPath = [];

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    path = Path()
      ..addOval(const Rect.fromLTRB(0, 0, 20, 20))
      ..close();
    bodyPaint = Paint()..color = const Color(0xFFFFB20D);
    addHitbox(
      HitboxCircle(
        size: Vector2(3, 3),
        normalizedRadius: 3 / 40,
      ),
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    bodyPaint.color = const Color(0xFFD60A0A);
    if (other is BoundaryLeft) {
      onBoundary = OnBoundary.left;
    }
    if (other is BoundaryRight) {
      onBoundary = OnBoundary.right;
    }
    if (other is BoundaryTop) {
      onBoundary = OnBoundary.top;
    }
    if (other is BoundaryBottom) {
      onBoundary = OnBoundary.bottom;
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    onBoundary = OnBoundary.none;
    if (other is BoundaryLeft) {
      bodyPaint.color = const Color(0xFFFFB20D);
    }
    if (other is BoundaryRight) {
      bodyPaint.color = const Color(0xFFFFB20D);
    }
    if (other is BoundaryTop) {
      bodyPaint.color = const Color(0xFFFFB20D);
    }
    if (other is BoundaryBottom) {
      bodyPaint.color = const Color(0xFFFFB20D);
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    Vector2 resizePosition = gameRef.initialPlayerPosition;
    for (final path in _directionPath) {
      switch (path.first) {
        case Direction.down:
          resizePosition += Vector2(0, gameRef.playboardSize.y * path.second);
          break;
        case Direction.left:
          resizePosition -= Vector2(gameRef.playboardSize.x * path.second, 0);
          break;
        case Direction.right:
          resizePosition += Vector2(gameRef.playboardSize.x * path.second, 0);
          break;
        case Direction.up:
          resizePosition -= Vector2(0, gameRef.playboardSize.y * path.second);
          break;
        default:
      }
    }

    position = resizePosition;
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
        position += Vector2(0, -_speed * gameRef.playboardSize.y);
        break;
      case Direction.down:
        position += Vector2(0, _speed * gameRef.playboardSize.y);
        break;
      case Direction.left:
        position += Vector2(-_speed * gameRef.playboardSize.x, 0);
        break;
      case Direction.right:
        position += Vector2(_speed * gameRef.playboardSize.x, 0);
        break;
      default:
        break;
    }
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    final renderDirectionPath = Path()..moveTo(10, 10);
    for (final direction in _directionPath.reversed) {
      switch (direction.first) {
        case Direction.down:
          renderDirectionPath.relativeLineTo(
              0, -direction.second * gameRef.playboardSize.y);
          break;
        case Direction.up:
          renderDirectionPath.relativeLineTo(
              0, direction.second * gameRef.playboardSize.y);
          break;
        case Direction.left:
          renderDirectionPath.relativeLineTo(
              direction.second * gameRef.playboardSize.x, 0);
          break;
        case Direction.right:
          renderDirectionPath.relativeLineTo(
              -direction.second * gameRef.playboardSize.x, 0);
          break;
        default:
      }
    }
    canvas.drawPath(
      renderDirectionPath,
      _directionPaint,
    );
    canvas.drawPath(path, bodyPaint);
  }

  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (Direction.up == lastDirection.opposite ||
            onBoundary == OnBoundary.top) {
          direction = Direction.none;
          return true;
        }
        direction = Direction.up;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (Direction.down == lastDirection.opposite ||
            onBoundary == OnBoundary.bottom) {
          direction = Direction.none;
          return true;
        }
        direction = Direction.down;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (Direction.left == lastDirection.opposite ||
            onBoundary == OnBoundary.left) {
          direction = Direction.none;
          return true;
        }

        direction = Direction.left;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (Direction.right == lastDirection.opposite ||
            onBoundary == OnBoundary.right) {
          direction = Direction.none;
          return true;
        }
        direction = Direction.right;
      } else {
        direction = Direction.none;
      }
    }

    return true;
  }
}
