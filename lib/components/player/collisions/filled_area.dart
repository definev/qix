import 'package:flame/extensions.dart';
import 'package:qix/components/background/filled_area.dart';
import 'package:qix/components/player/components/ball.dart';
import 'package:qix/components/utils/collision_between.dart';

class BallNFilledAreaCollision extends CollisionBetween<Ball, FilledArea> {
  BallNFilledAreaCollision(super.self, super.collided);

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints) {
    print('COLLIDE WITH FILLED AREA');
  }
}
