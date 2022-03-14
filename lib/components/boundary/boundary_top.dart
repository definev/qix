import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/painting.dart';

import '../../helpers/direction.dart';
import '../player.dart';
import 'common.dart';

class BoundaryTop extends PositionComponent //
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
      if (other.direction == const Direction.up()) {
        other.direction = const Direction.none();
      }
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    if (other is Player) {
      paint.color = noCollideColor;
      other.lastDirection.mapOrNull(
        left: (_) => other.direction = const Direction.down(),
        right: (_) => other.direction = const Direction.down(),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    size = Vector2(gameRef.size.x - 50, 0);
    position = Vector2.all(25);

    canvas.drawLine(const Offset(0, 0), Offset(size.x, 0), paint);
  }
}
