import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qix/components/background/boundary.dart';
import 'package:qix/components/background/filled_area.dart';
import 'package:qix/components/player/collisions/ball.dart';
import 'package:qix/components/player/collisions/filled_area.dart';
import 'package:qix/components/player/components/ball_line.dart';
import 'package:qix/components/player/managers/ball_manager.dart';
import 'package:qix/components/utils/collision_between.dart';
import 'package:qix/components/utils/debug_color.dart';
import 'package:qix/components/utils/has_manager.dart';
import 'package:qix/components/utils/priority.dart';
import 'package:qix/main.dart';

class Ball extends PositionComponent
    with //
        HasGameReference<QixGame>,
        KeyboardHandler,
        CollisionCallbacks,
        CollisionHandler<Ball>,
        HasManager<BallManager> {
  Ball({super.position});

  @override
  int get priority => GamePriority.ball;

  final _manager = BallManager();
  @override
  BallManager get manager => _manager;

  @override
  Color get debugColor => Colors.transparent;

  void loadAnchorPoint() {
    super.size = Vector2.all(16);

    add(RectangleHitbox(
      size: Vector2.all(1),
      position: center,
      isSolid: true,
      anchor: Anchor.center,
    )..debugColor = DebugColors.ball);
  }

  @override
  Future<void> onLoad() async {
    loadAnchorPoint();
  }

  @override
  void onMount() {
    super.onMount();
    mountColliables({
      Boundary: BallNBoundaryColision(this, boundary),
      FilledArea: BallNFilledAreaCollision(this, filledArea),
    });
  }

  @override
  void render(Canvas canvas) {
    final startAngle = () {
      switch (manager.direction) {
        case AxisDirection.down:
          return -pi / 6;
        case AxisDirection.up:
          return pi * 5 / 6;
        case AxisDirection.left:
          return pi / 3;
        case AxisDirection.right:
          return pi * 4 / 3;
        case null:
          return 0.0;
      }
    }();
    final sweepAngle = () {
      switch (manager.direction) {
        case null:
          return 2 * pi;
        default:
          return 4 * pi / 3;
      }
    }();

    canvas.drawArc(
      Rect.fromCenter(center: const Offset(8, 8), width: width, height: height),
      startAngle,
      sweepAngle,
      true,
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.orange, Colors.pink.shade500],
        ).createShader(Rect.fromLTRB(0, 0, size.x, size.y)),
    );
  }

  @override
  void update(double dt) {
    final dist = (manager.boost ? game.size.x / 2 : game.size.x / 10) * dt;

    switch (manager.direction) {
      case null:
        break;
      case AxisDirection.up:
        y -= dist;
        break;
      case AxisDirection.down:
        y += dist;
        break;
      case AxisDirection.left:
        x -= dist;
        break;
      case AxisDirection.right:
        x += dist;
        break;
    }
    if (center.x < boundary.topLeft.x) center = Vector2(boundary.topLeft.x, center.y);
    if (center.y < boundary.topLeft.y) center = Vector2(center.x, boundary.topLeft.y);
    if (center.x > boundary.bottomRight.x) center = Vector2(boundary.bottomRight.x, center.y);
    if (center.y > boundary.bottomRight.y) center = Vector2(center.x, boundary.bottomRight.y);
  }

  void _handleMovementKey(
    LogicalKeyboardKey key, {
    required LogicalKeyboardKey expected,
    required AxisDirection cancelAt,
    required AxisDirection to,
  }) {
    final prevDirection = manager.direction;

    if (key != expected) return;
    if (prevDirection == cancelAt) {
      manager.stop('cancel key');
      return;
    }
    manager.direction = to;
    final wall = boundary.onWall(center);
    final corner = boundary.onCorner(center);
    if (wall == null) manager.position = BallPosition.playground;

    if (wall == to) {
      manager.stop('onWall');
      manager.position = BallPosition.boundary;
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

    if (prevDirection != manager.direction && !collidingWith(filledArea) && ballLine.points.isNotEmpty) {
      ballLine.addPoint(center.clone());
    }
  }

  void _stopIfOutsideCorner(
    Alignment? corner,
    Alignment desireCorner, {
    required AxisDirection firstPreventDirection,
    required AxisDirection secondPreventDirection,
  }) {
    if (corner == desireCorner) {
      if (manager.direction == firstPreventDirection || manager.direction == firstPreventDirection) {
        manager.stop('on corner');
        manager.position = BallPosition.boundary;
      }
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event.isShiftPressed) {
      manager.boost = true;
    } else {
      manager.boost = false;
    }
    if (event.repeat) return true;

    if (keysPressed.length == 1) {
      final key = keysPressed.first;
      if (key == LogicalKeyboardKey.space) {
        manager.stop('PAUSE');
      }

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
    }

    return true;
  }
}
