import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/painting.dart';

import '../../helpers/direction.dart';
import '../player.dart';

class BoundaryRight extends PositionComponent //
    with
        HasGameRef,
        HasHitboxes,
        Collidable {
  Paint paint = Paint()
    ..color = const Color(0xFFFFFFFF)
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
      paint.color = const Color(0xF021FD3F);
      if (other.direction == const Direction.right()) {
        other.direction = const Direction.none();
      }
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    if (other is Player) {
      paint.color = const Color(0xFFFFFFFF);
      other.lastDirection.mapOrNull(
        up: (_) => other.direction = const Direction.left(),
        down: (_) => other.direction = const Direction.left(),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    size = Vector2(0, gameRef.size.y - 50);
    position = Vector2(gameRef.size.x - 25, 25);

    canvas.drawLine(const Offset(0, 0), Offset(0, size.y), paint);
  }
}
