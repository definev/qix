import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

class Boundary extends PositionComponent with HasGameReference, CollisionCallbacks, HasPaint {
  Boundary({super.children});

  EdgeInsets insets = const EdgeInsets.fromLTRB(40, 40, 40, 40);

  Vector2 get topLeft => Vector2(insets.left, insets.top);
  Vector2 get topRight => Vector2(game.size.x - insets.right, insets.top);
  Vector2 get bottomLeft => Vector2(insets.left, game.size.y - insets.bottom);
  Vector2 get bottomRight => Vector2(game.size.x - insets.right, game.size.y - insets.bottom);

  @override
  Paint get paint => Paint()
    ..color = Colors.green
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  void createWall() {
    add(RectangleHitbox(
      position: Vector2(insets.left, insets.top),
      size: Vector2(1, game.size.y - insets.vertical),
    ));
    add(RectangleHitbox(
      position: Vector2(game.size.x - insets.right, insets.top),
      size: Vector2(1, game.size.y - insets.vertical),
    ));
    add(RectangleHitbox(
      position: Vector2(insets.left, insets.top),
      size: Vector2(game.size.x - insets.horizontal, 1),
    ));
    add(RectangleHitbox(
      position: Vector2(insets.left, game.size.y - insets.bottom),
      size: Vector2(game.size.x - insets.horizontal, 1),
    ));
  }

  @override
  Future<void>? onLoad() async {
    createWall();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawLine(topLeft.toOffset(), topRight.toOffset(), paint);
    canvas.drawLine(topRight.toOffset(), bottomRight.toOffset(), paint);
    canvas.drawLine(bottomRight.toOffset(), bottomLeft.toOffset(), paint);
    canvas.drawLine(bottomLeft.toOffset(), topLeft.toOffset(), paint);
  }

  bool isCorner(Vector2 point) {
    point.round();
    final distToTopLeft = point.distanceTo(topLeft);
    if (distToTopLeft <= 4) return true;
    final distToTopRight = point.distanceTo(topRight);
    if (distToTopRight <= 4) return true;
    final distToBottomLeft = point.distanceTo(bottomLeft);
    if (distToBottomLeft <= 4) return true;
    final distToBottomRight = point.distanceTo(bottomRight);
    if (distToBottomRight <= 4) return true;
    return false;
  }
}
