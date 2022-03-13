import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/painting.dart';

import '../../helpers/direction.dart';
import '../player.dart';

class BoundaryBottom extends PositionComponent //
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
      if (other.direction == Direction.down) {
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
          other.direction = Direction.up;
          break;
        default:
      }
    }
  }

  @override
  void render(Canvas canvas) {
    size = Vector2(gameRef.size.x - 50, 0);
    position = Vector2(25, gameRef.size.y - 25);

    canvas.drawLine(Offset(0, size.y), Offset(size.x, 0), paint);
  }
}
