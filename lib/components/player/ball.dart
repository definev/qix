import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qix/components/background/boundary.dart';
import 'package:qix/components/player/ball_line.dart';

class Ball extends CircleComponent
    with //
        KeyboardHandler,
        ParentIsA<BallLine>,
        HasAncestor<Boundary>,
        CollisionCallbacks {
  Ball({
    super.radius = 8,
    super.position,
  });

  @override
  Paint get paint => Paint()..color = Colors.red;

  AxisDirection? direction;
  bool inPlayground = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(
      radius: 1,
      position: center,
      isSolid: true,
    ));
  }

  @override
  Color get debugColor => Colors.transparent;

  @override
  void render(Canvas canvas) {
    canvas.drawPath(
      Path() //
        ..moveTo(0, size.y / 2)
        ..lineTo(size.x / 2, 0)
        ..lineTo(size.x, size.y / 2)
        ..lineTo(size.x / 2, size.y)
        ..close(),
      Paint()..color = Colors.red,
    );
  }

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

  void _handleMovementKey(
    LogicalKeyboardKey key, {
    required LogicalKeyboardKey expected,
    required AxisDirection cancelAt,
    required AxisDirection to,
  }) {
    if (key == expected) {
      if (direction == cancelAt) {
        direction = null;
        return;
      }
      direction = to;
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event.repeat) return true;
    if (keysPressed.length == 1) {
      final key = keysPressed.first;
      final prevDirection = direction;

      _handleMovementKey(
        key,
        expected: LogicalKeyboardKey.arrowLeft,
        cancelAt: AxisDirection.right,
        to: AxisDirection.left,
      );
      _handleMovementKey(
        key,
        expected: LogicalKeyboardKey.arrowRight,
        cancelAt: AxisDirection.left,
        to: AxisDirection.right,
      );
      _handleMovementKey(
        key,
        expected: LogicalKeyboardKey.arrowDown,
        cancelAt: AxisDirection.up,
        to: AxisDirection.down,
      );
      _handleMovementKey(
        key,
        expected: LogicalKeyboardKey.arrowUp,
        cancelAt: AxisDirection.down,
        to: AxisDirection.up,
      );

      if (inPlayground && prevDirection != direction) {
        parent.addPoint(center.clone());
      }
    }

    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Boundary) {
      bool isCorner = intersectionPoints.fold(false, (val, point) {
        if (val) return true;
        point.round();
        if (point == other.topLeft) return true;
        if (point == other.topRight) return true;
        if (point == other.bottomLeft) return true;
        if (point == other.bottomRight) return true;
        return false;
      });
      if (inPlayground || isCorner) {
        direction = null;
        inPlayground = false;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is Boundary) {
      final currentPoint = parent.ball.center.clone();
      if (direction != null && !ancestor.isCorner(currentPoint)) {
        parent.addPoint(parent.ball.center);
      }
    }
    inPlayground = true;
  }
}