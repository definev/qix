import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/painting.dart';

import '../../helpers/direction.dart';
import '../player.dart';
import 'common.dart';

class BoundaryLeft extends PositionComponent //
    with
        HasGameRef,
        HasHitboxes,
        Collidable {
  Paint paint = Paint()
    ..color = noCollideColor
    ..strokeWidth = 3
    ..strokeJoin = StrokeJoin.bevel
    ..style = PaintingStyle.stroke;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    addHitbox(HitboxRectangle());
  }

  @override
  void onCollision(
    Set<Vector2> intersectionPoints,
    Collidable other,
  ) {
    if (other is Player) {
      paint.color = collideColor;
      if (other.direction == const Direction.left()) {
        other.direction = const Direction.none();
      }
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    if (other is Player) {
      paint.color = noCollideColor;
      other.lastDirection.mapOrNull(
        up: (_) => other.direction = const Direction.right(),
        down: (_) => other.direction = const Direction.right(),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    size = Vector2(0, gameRef.size.y - 50);
    position = Vector2.all(25);

    canvas.drawLine(const Offset(0, 0), Offset(0, size.y), paint);
  }
}
