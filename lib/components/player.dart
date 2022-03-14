import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
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
  var collidedBoundarySet = <Boundary>{const Boundary.bottom()};

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
                // down: (_) => renderDirectionPath.relativeMoveTo(
                down: (_) => renderDirectionPath.relativeLineTo(
                    0, -direction.second * gameRef.playboardSize.y),
                // left: (_) => renderDirectionPath.relativeMoveTo(
                left: (_) => renderDirectionPath.relativeLineTo(
                    direction.second * gameRef.playboardSize.x, 0),
                // right: (_) => renderDirectionPath.relativeMoveTo(
                right: (_) => renderDirectionPath.relativeLineTo(
                    -direction.second * gameRef.playboardSize.x, 0),
                // up: (_) => renderDirectionPath.relativeMoveTo(
                up: (_) => renderDirectionPath.relativeLineTo(
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
  bool get debugMode => true;

  @override
  void update(double dt) {
    super.update(dt);
    if (lastDirection != direction && direction != const Direction.none()) {
      bool canAddPath = direction.maybeMap(
        orElse: () => true,
        none: (dir) {
          if (dir.boundaryDirection != null &&
              lastDirection != dir.boundaryDirection) {
            return true;
          }
          return false;
        },
      );
      if (canAddPath) _directionPath.add(Tuple2(direction, 0));
    }

    direction.maybeMap(
      orElse: () {
        lastDirection = direction;
        _directionPath.last = _directionPath //
            .last
            .copyWith(value2: _directionPath.last.second + _speed);
      },
      none: (dir) {
        if (dir.boundaryDirection != null) {
          lastDirection = dir.boundaryDirection!;
          _directionPath.last = _directionPath //
              .last
              .copyWith(value2: _directionPath.last.second + _speed);
        }
      },
    );

    direction.mapOrNull(
        down: (_) => position += Vector2(0, gameRef.playboardSize.y * _speed),
        left: (_) => position += Vector2(-gameRef.playboardSize.x * _speed, 0),
        right: (_) => position += Vector2(gameRef.playboardSize.x * _speed, 0),
        up: (_) => position += Vector2(0, -gameRef.playboardSize.y * _speed),
        none: (dir) {
          if (dir.boundaryDirection != null) {
            dir.boundaryDirection!.mapOrNull(
              down: (_) =>
                  position += Vector2(0, gameRef.playboardSize.y * _speed),
              left: (_) =>
                  position += Vector2(-gameRef.playboardSize.x * _speed, 0),
              right: (_) =>
                  position += Vector2(gameRef.playboardSize.x * _speed, 0),
              up: (_) =>
                  position += Vector2(0, -gameRef.playboardSize.y * _speed),
            );
          }
        });
  }

  @override
  void render(Canvas canvas) {
    final renderDirectionPath = _drawDirectionPath();
    canvas.drawPath(renderDirectionPath..close(), _directionPaint);
    canvas.drawPath(path, bodyPaint);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    bodyPaint.color = const Color(0xFFD60A0A);
    if (other is BoundaryLeft) {
      direction.mapOrNull(
        none: (dir) {
          if (dir.boundaryDirection != null) {
            dir.boundaryDirection!
                .mapOrNull(left: (_) => direction = const Direction.none());
          }
        },
      );
      collidedBoundarySet.add(const Boundary.left());
    }
    if (other is BoundaryRight) {
      direction.mapOrNull(
        none: (dir) {
          if (dir.boundaryDirection != null) {
            dir.boundaryDirection!
                .mapOrNull(right: (_) => direction = const Direction.none());
          }
        },
      );
      collidedBoundarySet.add(const Boundary.right());
    }
    if (other is BoundaryTop) {
      direction.mapOrNull(
        none: (dir) {
          if (dir.boundaryDirection != null) {
            dir.boundaryDirection!
                .mapOrNull(up: (_) => direction = const Direction.none());
          }
        },
      );
      collidedBoundarySet.add(const Boundary.top());
    }
    if (other is BoundaryBottom) {
      direction.mapOrNull(
        none: (dir) {
          if (dir.boundaryDirection != null) {
            dir.boundaryDirection!
                .mapOrNull(down: (_) => direction = const Direction.none());
          }
        },
      );
      collidedBoundarySet.add(const Boundary.bottom());
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    bodyPaint.color = const Color(0xFFFFB20D);
    if (other is BoundaryLeft) {
      collidedBoundarySet.remove(const Boundary.left());
    }
    if (other is BoundaryRight) {
      collidedBoundarySet.remove(const Boundary.right());
    }
    if (other is BoundaryTop) {
      collidedBoundarySet.remove(const Boundary.top());
    }
    if (other is BoundaryBottom) {
      collidedBoundarySet.remove(const Boundary.bottom());
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    Vector2 resizePosition = _rePositioningPlayer(gameRef.playboardSize);
    position = resizePosition;
  }

  bool _isOppositeDirection(Direction direction) {
    return lastDirection.opposite == direction;
  }

  void _moveTo({
    required Direction direction,
    required Set<Boundary> allowBoundarySet,
  }) {
    if (gameRef.isOutOfBounds(direction)) {
      return;
    }
    if (collidedBoundarySet.intersection(allowBoundarySet).isNotEmpty) {
      this.direction = Direction.none(direction);
      return;
    }
    if (_isOppositeDirection(direction)) {
      // this.direction = const Direction.none();
      return;
    }

    this.direction = direction;
  }

  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _moveTo(
          direction: const Direction.up(),
          allowBoundarySet: {const Boundary.left(), const Boundary.right()},
        );
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _moveTo(
          direction: const Direction.down(),
          allowBoundarySet: {const Boundary.left(), const Boundary.right()},
        );
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _moveTo(
          direction: const Direction.left(),
          allowBoundarySet: {const Boundary.top(), const Boundary.bottom()},
        );
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _moveTo(
          direction: const Direction.right(),
          allowBoundarySet: {const Boundary.top(), const Boundary.bottom()},
        );
      } else {
        direction = const Direction.none();
      }
    }

    return true;
  }
}
