import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qix/components/background/boundary.dart';
import 'package:qix/components/player/ball_line.dart';
import 'package:qix/main.dart';

enum BallPosition { playground, boundary }

class Ball extends CircleComponent
    with //
        HasGameReference<QixGame>,
        KeyboardHandler,
        ParentIsA<BallLine>,
        HasAncestor<Boundary>,
        CollisionCallbacks {
  Ball({
    super.radius = 8,
    super.position,
  });

  AxisDirection? _direction;
  void stop([String? from]) {
    if (from != null) print('STOP FROM : $from');
    _direction = null;
  }

  BallPosition ballPosition = BallPosition.boundary;
  late CircleHitbox cue;

  @override
  Paint get paint => Paint()..color = Colors.red;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(cue = CircleHitbox(
      radius: 1,
      position: center,
      isSolid: true,
      anchor: Anchor.center,
    )..debugColor = Colors.cyan);
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
      Paint()
        ..shader = LinearGradient(
          colors: [Colors.orange.shade100, Colors.pink.shade500],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTRB(0, 0, size.x, size.y)),
    );
  }

  @override
  void update(double dt) {
    final dist = 60 * dt;
    final current = position.clone();

    switch (_direction) {
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
      if (_direction == cancelAt) {
        stop('cancel key');
        return;
      }
      _direction = to;
      final onWall = ancestor.onWall(center);
      final onCorner = ancestor.onCorner(center);
      if (onWall == null) {
        ballPosition = BallPosition.playground;
      }
      if (onWall == to) {
        stop('onWall');
        ballPosition = BallPosition.boundary;
      }

      if (onCorner == Alignment.topLeft) {
        if (to == AxisDirection.up || to == AxisDirection.left) {
          stop('on corner');
          ballPosition = BallPosition.boundary;
        }
      }
      if (onCorner == Alignment.topRight) {
        if (to == AxisDirection.up || to == AxisDirection.right) {
          stop('on corner');
          ballPosition = BallPosition.boundary;
        }
      }

      if (onCorner == Alignment.bottomLeft) {
        if (to == AxisDirection.down || to == AxisDirection.left) {
          stop('on corner');
          ballPosition = BallPosition.boundary;
        }
      }

      if (onCorner == Alignment.bottomRight) {
        if (to == AxisDirection.down || to == AxisDirection.right) {
          stop('on corner');
          ballPosition = BallPosition.boundary;
        }
      }
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event.repeat) return true;
    if (keysPressed.length == 1) {
      final key = keysPressed.first;
      final prevDirection = _direction;

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

      if (prevDirection != _direction && !collidingWith(ancestor)) {
        parent.addPoint(center.clone());
      }
    }

    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Boundary) {
      onBoundaryCollided(intersectionPoints, other);
    }
  }

  void onBoundaryCollided(Set<Vector2> intersectionPoints, Boundary other) {
    bool isCorner = intersectionPoints.fold(false, (val, point) {
      if (val) return true;
      point.round();
      if (point == other.topLeft) return true;
      if (point == other.topRight) return true;
      if (point == other.bottomLeft) return true;
      if (point == other.bottomRight) return true;
      return false;
    });
    if (ballPosition == BallPosition.playground || isCorner) {
      stop('boundary');
      ballPosition = BallPosition.boundary;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is Boundary) {
      final currentPoint = center.clone();
      final onCorner = ancestor.isCorner(currentPoint);
      if (_direction != null && !onCorner) {
        parent.addPoint(parent.ball.center.clone());
      }
    }
  }
}
