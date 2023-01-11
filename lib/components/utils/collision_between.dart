import 'package:flame/components.dart';

abstract class CollisionBetween<S extends PositionComponent, O extends PositionComponent> {
  final S self;
  final O collided;

  CollisionBetween(this.self, this.collided);

  void onCollision(Set<Vector2> intersectionPoints);

  void onCollisionStart(Set<Vector2> intersectionPoints);

  void onCollisionEnd();
}
