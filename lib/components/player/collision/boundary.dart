import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';
import 'package:qix/components/background/boundary.dart';
import 'package:qix/components/player/ball.dart';
import 'package:qix/components/utils/collision_between.dart';
import 'package:qix/components/utils/polygon.dart';

class BallNBoundaryColision extends CollisionBetween<Ball, Boundary> {
  BallNBoundaryColision(super.self, super.collided);

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
        if (self.direction == firstPreventDirection || self.direction == secondPreventDirection) {
          print(
              'ALIGN : $alignment | $firstPreventDirection | $secondPreventDirection | DIRECTION : ${self.direction}');
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
    final direction = self.direction;
    if (direction != null && !onCorner) {
      final point = self.center.clone();
      switch (direction) {
        case AxisDirection.down:
          point.y = point.y.floorToDouble() - 1;
          break;
        case AxisDirection.up:
          point.y = point.y.ceilToDouble() + 1;
          break;
        case AxisDirection.left:
          point.x = point.x.ceilToDouble() + 1;
          break;
        case AxisDirection.right:
          point.x = point.x.floorToDouble() - 1;
          break;
      }
      print('INITAL POINT : $point');
      self.parent.addPoint(point);
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints) {
    final ballLine = self.parent;
    if (ballLine.points.isEmpty) return;
    final center = self.center.clone();
    final start = ballLine.points.first;
    final end = Vector2(
      self.direction == AxisDirection.left
          ? center.x.floorToDouble()
          : self.direction == AxisDirection.right
              ? center.x.ceilToDouble()
              : center.x,
      self.direction == AxisDirection.up
          ? center.y.floorToDouble()
          : self.direction == AxisDirection.down
              ? center.y.ceilToDouble()
              : center.y,
    );
    final points = [...ballLine.points, end];
    final filledArea = ballLine.parent;

    if (start.x == end.x || start.y == end.y) {
      filledArea.addArea(points);
    } else {
      final corner = _findClosestCorner(start, end);
      if (corner != null) {
        filledArea.addArea(points..add(corner));
      } else {
        // Calculate filled area and decide which are we will choose (the smaller one)
        if (isVertical(start, end)) {
          final polygonTop = [
            if (start.x > end.x) collided.topLeft else collided.topRight,
            ...points,
            if (start.x > end.x) collided.topRight else collided.topLeft,
          ];
          final polygonBottom = [
            if (start.x > end.x) collided.bottomLeft else collided.bottomRight,
            ...points,
            if (start.x > end.x) collided.bottomRight else collided.bottomLeft,
          ];
          if (PolygonUtils.calculateArea(polygonTop) > PolygonUtils.calculateArea(polygonBottom)) {
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
  }

  bool isVertical(Vector2 start, Vector2 end) =>
      (start.x == collided.topLeft.x && end.x == collided.topRight.x) ||
      (end.x == collided.topLeft.x && start.x == collided.topRight.x);
}
