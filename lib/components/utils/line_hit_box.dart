import 'package:flame/collisions.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class LineHitBox {
  static RectangleHitbox create({
    required Vector2 from,
    required Vector2 to,
  }) {
    RectangleHitbox? hitbox;

    if (from.x == to.x) {
      if (from.y > to.y) {
        hitbox = RectangleHitbox(
          position: to,
          size: Vector2(1, from.y - to.y),
        );
      } else {
        hitbox = RectangleHitbox(
          position: from,
          size: Vector2(1, to.y - from.y),
        );
      }
    }

    if (from.y == to.y) {
      if (from.x > to.x) {
        hitbox = RectangleHitbox(
          position: to,
          size: Vector2(from.x - to.x, 1),
        );
      } else {
        hitbox = RectangleHitbox(
          position: from,
          size: Vector2(to.x - from.x, 1),
        );
      }
    }

    hitbox?.debugColor = Colors.orange;

    return hitbox!;
  }
}
