import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';
import 'package:qix/components/background/boundary.dart';
import 'package:qix/components/player/ball.dart';
import 'package:qix/components/utils/collision_between.dart';

class BallNBoundaryColision extends CollisionBetween<Ball, Boundary> {
  BallNBoundaryColision(super.self, super.collided);

  @override
  void onCollision(Set<Vector2> intersectionPoints) {
    Vector2? corner = intersectionPoints.fold(null, (val, point) {
      final p = point..round();
      if (val != null) return val;
      if (p == collided.topLeft) return collided.topLeft;
      if (p == collided.topRight) return collided.topRight;
      if (p == collided.bottomLeft) return collided.bottomLeft;
      if (p == collided.bottomRight) return collided.bottomRight;
      return null;
    });
    bool preventOutOfCorner = false;

    bool checkPreventOutOfCorner(
      Alignment alignment,
      Alignment desireAlignment, {
      required AxisDirection firstPreventDirection,
      required AxisDirection secondPreventDirection,
    }) {
      if (alignment == desireAlignment) {
        if (self.direction == firstPreventDirection || self.direction == secondPreventDirection) {
          return true;
        }
      }
      return false;
    }

    if (corner != null) {
      if (self.ballPosition != BallPosition.corner) self.center = corner;

      final alignment = collided.onCorner(self.center)!;
      preventOutOfCorner = checkPreventOutOfCorner(
            alignment,
            Alignment.topLeft,
            firstPreventDirection: AxisDirection.left,
            secondPreventDirection: AxisDirection.up,
          ) ||
          checkPreventOutOfCorner(
            alignment,
            Alignment.topRight,
            firstPreventDirection: AxisDirection.right,
            secondPreventDirection: AxisDirection.up,
          ) ||
          checkPreventOutOfCorner(
            alignment,
            Alignment.bottomLeft,
            firstPreventDirection: AxisDirection.left,
            secondPreventDirection: AxisDirection.down,
          ) ||
          checkPreventOutOfCorner(
            alignment,
            Alignment.bottomRight,
            firstPreventDirection: AxisDirection.right,
            secondPreventDirection: AxisDirection.down,
          );

      if (self.ballPosition != BallPosition.corner) self.ballPosition = BallPosition.corner;
    } else {
      if (self.ballPosition == BallPosition.corner) {
        self.ballPosition = BallPosition.boundary;
      }
    }

    if (self.ballPosition == BallPosition.playground || preventOutOfCorner) {
      self.stop('boundary');
      self.ballPosition = BallPosition.boundary;
    }
  }

  @override
  void onCollisionEnd() {
    final currentPoint = self.center.clone()..round();
    final onCorner = self.ancestor.isCorner(currentPoint);
    if (self.direction != null && !onCorner) {
      self.parent.addPoint(self.parent.ball.center.clone());
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints) {
    final ballLine = self.parent;
    if (ballLine.points.isEmpty) return;
    final points = [...ballLine.points, self.center];
    final filledArea = ballLine.parent;
    filledArea.addArea(points);
    ballLine.resetLine();
  }
}
