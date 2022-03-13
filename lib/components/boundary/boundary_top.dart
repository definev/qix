import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/painting.dart';

import '../../helpers/direction.dart';
import '../player.dart';

class BoundaryTop extends PositionComponent //
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
      if (other.direction == Direction.up) {
        other.direction = Direction.none;
      }
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    if (other is Player) {
      paint.color = const Color(0xFFFFFFFF);
      switch (other.lastDirection) {
        case Direction.left:
        case Direction.right:
          other.direction = Direction.down;
          break;
        default:
      }
    }
  }

  @override
  void render(Canvas canvas) {
    size = Vector2(gameRef.size.x - 50, 0);
    position = Vector2.all(25);

    canvas.drawLine(const Offset(0, 0), Offset(size.x, 0), paint);
  }
}
