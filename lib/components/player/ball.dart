import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qix/components/background/boundary.dart';
import 'package:qix/components/player/ball_line.dart';
import 'package:qix/components/player/collision/boundary.dart';
import 'package:qix/main.dart';

enum BallPosition { playground, boundary, corner }

class Ball extends CircleComponent
    with //
        HasGameReference<QixGame>,
        HasAncestor<Boundary>,
        ParentIsA<BallLine>,
        KeyboardHandler,
        CollisionCallbacks {
  Ball({
    super.radius = 8,
    super.position,
  });

  AxisDirection? _direction;
  AxisDirection? get direction => _direction;

  void stop([String? from]) {
    if (from != null) debugPrint('STOP FROM : $from');
    _direction = null;
  }

  BallPosition ballPosition = BallPosition.boundary;
  late CircleHitbox cue;

  late final BallNBoundaryColision _boundaryCollision;

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
  void onMount() {
    super.onMount();
    _boundaryCollision = BallNBoundaryColision(this, ancestor);
  }

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
    print(center);

    switch (_direction) {
      case null:
        break;
      case AxisDirection.up:
        position += Vector2(0, -dist);
        break;
      case AxisDirection.down:
        position += Vector2(0, dist);
        break;
      case AxisDirection.left:
        position += Vector2(-dist, 0);
        break;
      case AxisDirection.right:
        position += Vector2(dist, 0);
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
      final wall = ancestor.onWall(center);
      final corner = ancestor.onCorner(center);
      if (wall == null) ballPosition = BallPosition.playground;

      if (wall == to) {
        stop('onWall');
        ballPosition = BallPosition.boundary;
      }

      _stopIfOutsideCorner(
        corner,
        Alignment.topLeft,
        firstPreventDirection: AxisDirection.up,
        secondPreventDirection: AxisDirection.left,
      );
      _stopIfOutsideCorner(
        corner,
        Alignment.topRight,
        firstPreventDirection: AxisDirection.up,
        secondPreventDirection: AxisDirection.right,
      );
      _stopIfOutsideCorner(
        corner,
        Alignment.bottomLeft,
        firstPreventDirection: AxisDirection.down,
        secondPreventDirection: AxisDirection.left,
      );
      _stopIfOutsideCorner(
        corner,
        Alignment.bottomRight,
        firstPreventDirection: AxisDirection.down,
        secondPreventDirection: AxisDirection.right,
      );
    }
  }

  void _stopIfOutsideCorner(
    Alignment? corner,
    Alignment desireCorner, {
    required AxisDirection firstPreventDirection,
    required AxisDirection secondPreventDirection,
  }) {
    if (corner == desireCorner) {
      if (_direction == firstPreventDirection || _direction == firstPreventDirection) {
        stop('on corner');
        ballPosition = BallPosition.boundary;
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
      _boundaryCollision.onCollision(intersectionPoints);
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Boundary) {
      _boundaryCollision.onCollisionStart(intersectionPoints);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is Boundary) {
      _boundaryCollision.onCollisionEnd();
    }
  }
}
