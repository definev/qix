import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:qix/components/utils/line_hit_box.dart';

class Boundary extends PositionComponent with HasGameReference, HasPaint {
  Boundary({super.children});

  EdgeInsets insets = const EdgeInsets.all(50);

  Vector2 get topLeft => Vector2(insets.left, insets.top);
  Vector2 get topRight => Vector2(game.size.x - insets.right, insets.top);
  Vector2 get bottomLeft => Vector2(insets.left, game.size.y - insets.bottom);
  Vector2 get bottomRight => Vector2(game.size.x - insets.right, game.size.y - insets.bottom);

  late LineHitBox leftWall;
  late LineHitBox rightWall;
  late LineHitBox topWall;
  late LineHitBox bottomWall;

  AxisDirection? onWall(Vector2 point) {
    final p = point.clone()..ceil();
    Set<Vector2> points = {
      p + Vector2(0, -1),
      p + Vector2(-1, 0),
      p,
      p + Vector2(1, 0),
      p + Vector2(0, 1),
    };

    bool isOnWall(LineHitBox wall) {
      for (var p in points) {
        if (wall.containsPoint(p)) return true;
      }
      return false;
    }

    if (isOnWall(leftWall)) return AxisDirection.left;
    if (isOnWall(rightWall)) return AxisDirection.right;
    if (isOnWall(topWall)) return AxisDirection.up;
    if (isOnWall(bottomWall)) return AxisDirection.down;
    return null;
  }

  @override
  Paint get paint => Paint()
    ..color = Colors.green
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  void createWall() {
    leftWall = LineHitBox.create(from: topLeft, to: bottomLeft);
    topWall = LineHitBox.create(from: topLeft, to: topRight);
    rightWall = LineHitBox.create(from: topRight, to: bottomRight);
    bottomWall = LineHitBox.create(from: bottomLeft, to: bottomRight);
  }

  void updateWall() {
    leftWall.position = Vector2(insets.left, insets.top);
    leftWall.size = Vector2(1, game.size.y - insets.vertical);

    rightWall.position = Vector2(game.size.x - insets.right, insets.top);
    rightWall.size = Vector2(1, game.size.y - insets.vertical);

    topWall.position = Vector2(insets.left, insets.top);
    topWall.size = Vector2(game.size.x - insets.horizontal, 1);

    bottomWall.position = Vector2(insets.left, game.size.y - insets.bottom);
    bottomWall.size = Vector2(game.size.x - insets.horizontal, 1);
  }

  @override
  Future<void>? onLoad() async {
    createWall();
    add(PolygonHitbox([topLeft, topRight, bottomRight, bottomLeft], isSolid: false));
  }

  @override
  void render(Canvas canvas) {
    canvas.drawLine(topLeft.toOffset(), topRight.toOffset(), paint);
    canvas.drawLine(topRight.toOffset(), bottomRight.toOffset(), paint);
    canvas.drawLine(bottomRight.toOffset(), bottomLeft.toOffset(), paint);
    canvas.drawLine(bottomLeft.toOffset(), topLeft.toOffset(), paint);
  }

  bool isCorner(Vector2 point) {
    final distToTopLeft = point.distanceTo(topLeft);
    if (distToTopLeft <= 2) return true;
    final distToTopRight = point.distanceTo(topRight);
    if (distToTopRight <= 2) return true;
    final distToBottomLeft = point.distanceTo(bottomLeft);
    if (distToBottomLeft <= 2) return true;
    final distToBottomRight = point.distanceTo(bottomRight);
    if (distToBottomRight <= 2) return true;
    return false;
  }

  Alignment? onCorner(Vector2 point) {
    final distToTopLeft = point.distanceTo(topLeft);
    if (distToTopLeft <= 2) return Alignment.topLeft;
    final distToTopRight = point.distanceTo(topRight);
    if (distToTopRight <= 2) return Alignment.topRight;
    final distToBottomLeft = point.distanceTo(bottomLeft);
    if (distToBottomLeft <= 2) return Alignment.bottomLeft;
    final distToBottomRight = point.distanceTo(bottomRight);
    if (distToBottomRight <= 2) return Alignment.bottomRight;
    return null;
  }
}
