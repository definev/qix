import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';

import '../helpers/direction.dart';
import '../qix_game.dart';
import 'boundary/boundary.dart';
import 'boundary/on_boundary.dart';

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

  var direction = const Direction.none();
  var lastDirection = const Direction.none();
  var onBoundarySet = <Boundary>{const Boundary.bottom()};

  final List<Tuple2<Direction, double>> _directionPath = [];

  Vector2 _rePositioningPlayer(Vector2 size) {
    Vector2 resizePosition = gameRef.initialPlayerPosition;
    for (final path in _directionPath) {
      path.first.mapOrNull(
        down: (_) => resizePosition += Vector2(0, size.y * path.second),
        left: (_) => resizePosition += Vector2(-size.x * path.second, 0),
        right: (_) => resizePosition += Vector2(size.x * path.second, 0),
        up: (_) => resizePosition += Vector2(0, -size.y * path.second),
      );
    }

    return resizePosition;
  }

  Path _drawDirectionPath() {
    final renderDirectionPath = Path()..moveTo(10, 10);
    for (final direction in _directionPath.reversed) {
      direction.first.mapOrNull(
          down: (_) => renderDirectionPath.relativeLineTo(
              0, -direction.second * gameRef.playboardSize.y),
          left: (_) => renderDirectionPath.relativeLineTo(
              direction.second * gameRef.playboardSize.x, 0),
          right: (_) => renderDirectionPath.relativeLineTo(
              -direction.second * gameRef.playboardSize.x, 0),
          up: (_) => renderDirectionPath.relativeLineTo(
              0, direction.second * gameRef.playboardSize.y),
          none: (dir) {
            if (dir.boundaryDirection != null) {
              dir.boundaryDirection!.mapOrNull(
                down: (_) => renderDirectionPath.relativeMoveTo(
                    0, -direction.second * gameRef.playboardSize.y),
                left: (_) => renderDirectionPath.relativeMoveTo(
                    direction.second * gameRef.playboardSize.x, 0),
                right: (_) => renderDirectionPath.relativeMoveTo(
                    -direction.second * gameRef.playboardSize.x, 0),
                up: (_) => renderDirectionPath.relativeMoveTo(
                    0, direction.second * gameRef.playboardSize.y),
              );
            }
          });
    }
    return renderDirectionPath;
  }

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
  void update(double dt) {
    if (lastDirection != direction && direction != const Direction.none()) {
      _directionPath.add(Tuple2(direction, 0));
    }

    direction.maybeMap(
      orElse: () {
        lastDirection = direction;
        _directionPath.last = _directionPath.last.copyWith(
          value2: _directionPath.last.second + _speed,
        );
      },
      none: (_) {},
    );

    direction.mapOrNull(
      down: (_) => position += Vector2(0, gameRef.playboardSize.y * _speed),
      left: (_) => position += Vector2(-gameRef.playboardSize.x * _speed, 0),
      right: (_) => position += Vector2(gameRef.playboardSize.x * _speed, 0),
      up: (_) => position += Vector2(0, -gameRef.playboardSize.y * _speed),
    );

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    final renderDirectionPath = _drawDirectionPath();
    canvas.drawPath(renderDirectionPath, _directionPaint);
    canvas.drawPath(path, bodyPaint);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    bodyPaint.color = const Color(0xFFD60A0A);
    if (other is BoundaryLeft) {
      onBoundarySet.add(const Boundary.left());
    }
    if (other is BoundaryRight) {
      onBoundarySet.add(const Boundary.right());
    }
    if (other is BoundaryTop) {
      onBoundarySet.add(const Boundary.top());
    }
    if (other is BoundaryBottom) {
      onBoundarySet.add(const Boundary.bottom());
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    bodyPaint.color = const Color(0xFFFFB20D);
    if (other is BoundaryLeft) {
      onBoundarySet.remove(const Boundary.left());
    }
    if (other is BoundaryRight) {
      onBoundarySet.remove(const Boundary.right());
    }
    if (other is BoundaryTop) {
      onBoundarySet.remove(const Boundary.top());
    }
    if (other is BoundaryBottom) {
      onBoundarySet.remove(const Boundary.bottom());
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    Vector2 resizePosition = _rePositioningPlayer(gameRef.playboardSize);
    position = resizePosition;
  }

  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (lastDirection.opposite == const Direction.up() ||
            onBoundarySet.contains(const Boundary.top())) {
          direction = const Direction.none();
          return true;
        }
        direction = const Direction.up();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (lastDirection.opposite == const Direction.down() ||
            onBoundarySet.contains(const Boundary.bottom())) {
          direction = const Direction.none();
          return true;
        }
        direction = const Direction.down();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (lastDirection.opposite == const Direction.left() ||
            onBoundarySet.contains(const Boundary.left())) {
          direction = const Direction.none();
          return true;
        }

        direction = const Direction.left();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (lastDirection.opposite == const Direction.right() ||
            onBoundarySet.contains(const Boundary.right())) {
          direction = const Direction.none();
          return true;
        }
        direction = const Direction.right();
      } else {
        direction = const Direction.none();
      }
    }

    return true;
  }
}
