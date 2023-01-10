import 'package:flame/collisions.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class LineHitBox extends RectangleHitbox {
  LineHitBox._({super.position, super.size});

  factory LineHitBox.create({
    required Vector2 from,
    required Vector2 to,
  }) {
    LineHitBox? hitbox;

    if (from.x == to.x) {
      if (from.y > to.y) {
        hitbox = LineHitBox._(
          position: to,
          size: Vector2(1, from.y - to.y),
        );
      } else {
        hitbox = LineHitBox._(
          position: from,
          size: Vector2(1, to.y - from.y),
        );
      }
    }

    if (from.y == to.y) {
      if (from.x > to.x) {
        hitbox = LineHitBox._(
          position: to,
          size: Vector2(from.x - to.x, 1),
        );
      } else {
        hitbox = LineHitBox._(
          position: from,
          size: Vector2(to.x - from.x, 1),
        );
      }
    }

    hitbox?.debugColor = Colors.orange;

    return hitbox!;
  }
}
