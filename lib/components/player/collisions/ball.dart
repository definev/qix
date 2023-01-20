import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qix/components/background/boundary.dart';
import 'package:qix/components/player/components/ball.dart';
import 'package:qix/components/player/managers/ball_manager.dart';
import 'package:qix/components/utils/collision_between.dart';
import 'package:qix/components/utils/polygon.dart';

class BallNBoundaryColision extends CollisionBetween<Ball, Boundary> {
  BallNBoundaryColision(super.self, super.collided);

  BallManager get manager => self.manager;

  Vector2 get _currentPoint {
    final point = Vector2(
      clampDouble(self.center.x, collided.topLeft.x, collided.topRight.x),
      clampDouble(self.center.y, collided.topLeft.y, collided.bottomLeft.y),
    );
    return point;
  }

  Vector2? _findClosestCorner(Vector2 start, Vector2 end) {
    final potentialCornerOne = Vector2(start.x, end.y);
    final potentialCornerTwo = Vector2(end.x, start.y);
    if (collided.isCorner(potentialCornerOne)) {
      return potentialCornerOne;
    }
    if (collided.isCorner(potentialCornerTwo)) {
      return potentialCornerTwo;
    }
    return null;
  }

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
        if (manager.direction == firstPreventDirection || manager.direction == secondPreventDirection) {
          print(
              'ALIGN : $alignment | $firstPreventDirection | $secondPreventDirection | DIRECTION : ${manager.direction}');
          return true;
        }
      }
      return false;
    }

    if (corner != null) {
      if (manager.ballPosition != BallPosition.corner) self.center = corner;

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

      if (manager.ballPosition != BallPosition.corner) manager.ballPosition = BallPosition.corner;
    } else {
      if (manager.ballPosition == BallPosition.corner) {
        manager.ballPosition = BallPosition.boundary;
      }
    }

    if (manager.ballPosition == BallPosition.playground || preventOutOfCorner) {
      manager.stop('boundary');
      manager.ballPosition = BallPosition.boundary;
    }
  }

  @override
  void onCollisionEnd() {
    final currentPoint = _currentPoint;

    final onCorner = self.ancestor.parent.isCorner(currentPoint);
    if (onCorner == true) {
      manager.stop('on corner');
      self.center = currentPoint;
    }
    final direction = manager.direction;
    if (direction != null && !onCorner) {
      switch (manager.direction) {
        case AxisDirection.down:
          currentPoint.y = collided.topLeft.y;
          break;
        case AxisDirection.up:
          currentPoint.y = collided.bottomLeft.y;
          break;
        case AxisDirection.left:
          currentPoint.x = collided.topRight.x;
          break;
        case AxisDirection.right:
          currentPoint.x = collided.topLeft.x;
          break;
        default:
      }

      debugPrint('INITAL POINT : $currentPoint');
      self.parent.addPoint(currentPoint);
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints) {
    final ballLine = self.parent;
    if (ballLine.points.isEmpty) return;

    final direction = self.manager.direction;

    final center = _currentPoint;
    final start = ballLine.points.first;
    final end = Vector2(
      direction == AxisDirection.left
          ? collided.topLeft.x
          : direction == AxisDirection.right
              ? collided.topRight.x
              : center.x,
      direction == AxisDirection.up
          ? collided.topLeft.y
          : direction == AxisDirection.down
              ? collided.bottomLeft.y
              : center.y,
    );
    final points = [...ballLine.points, end];
    final filledArea = ballLine.parent;

    if ((start.x == end.x && (start.x == collided.topLeft.x || start.x == collided.topRight.x)) ||
        start.y == end.y && (start.y == collided.topLeft.y || start.y == collided.bottomLeft.y)) {
      filledArea.addArea(points);
    } else {
      final corner = _findClosestCorner(start, end);
      if (corner != null) {
        filledArea.addArea(points..add(corner));
      } else {
        // Calculate filled area and decide which are we will choose (the smaller one)
        if (isVertical(start, end)) {
          final polygonTop = [
            if (start.x > end.x) collided.topRight else collided.topLeft,
            ...points,
            if (start.x > end.x) collided.topLeft else collided.topRight,
          ];
          final polygonBottom = [
            if (start.x > end.x) collided.bottomRight else collided.bottomLeft,
            ...points,
            if (start.x > end.x) collided.bottomLeft else collided.bottomRight,
          ];
          final topArea = PolygonUtils.calculateArea(polygonTop);
          final bottomArea = PolygonUtils.calculateArea(polygonBottom);
          if (topArea > bottomArea) {
            filledArea.addArea(polygonBottom);
          } else {
            filledArea.addArea(polygonTop);
          }
        } else {
          final polygonLeft = [
            if (start.y > end.y) collided.bottomLeft else collided.topLeft,
            ...points,
            if (start.y > end.y) collided.topLeft else collided.bottomLeft,
          ];
          final polygonRight = [
            if (start.y > end.y) collided.bottomRight else collided.topRight,
            ...points,
            if (start.y > end.y) collided.topRight else collided.bottomRight,
          ];
          final leftArea = PolygonUtils.calculateArea(polygonLeft);
          final rightArea = PolygonUtils.calculateArea(polygonRight);

          if (leftArea > rightArea) {
            filledArea.addArea(polygonRight);
          } else {
            filledArea.addArea(polygonLeft);
          }
        }
      }
    }

    ballLine.resetLine();
    manager.stop();
  }

  bool isVertical(Vector2 start, Vector2 end) =>
      (start.x == collided.topLeft.x && end.x == collided.topRight.x) ||
      (end.x == collided.topLeft.x && start.x == collided.topRight.x);
}

