import 'package:flame/extensions.dart';
import 'package:qix/components/player/components/ball.dart';
import 'package:qix/components/player/components/ball_line.dart';
import 'package:qix/components/utils/collision_between.dart';

class BallLineNBallCollision extends CollisionBetween<BallLine, Ball> {
  BallLineNBallCollision(super.self, super.collided);

  @override
  void onCollision(Set<Vector2> intersectionPoints) {
    if (!collided.collidingWith(self.ancestor)) {
      collided.manager.stop('ball line collision with fillled area');
    }
  }
}
