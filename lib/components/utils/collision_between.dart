import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

abstract class CollisionBetween<S extends PositionComponent, O extends PositionComponent> {
  final S self;
  final O collided;

  CollisionBetween(this.self, this.collided);

  void onCollision(Set<Vector2> intersectionPoints) {}

  void onCollisionStart(Set<Vector2> intersectionPoints) {}

  void onCollisionEnd() {}
}

mixin CollisionHandler<T extends PositionComponent> on CollisionCallbacks {
  Map<Type, CollisionBetween<T, dynamic>> collidables = {};

  void mountColliables(Map<Type, CollisionBetween<T, dynamic>> initial) {
    collidables = initial;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    final entries = collidables.entries;
    for (final collidable in entries) {
      if (other.runtimeType == collidable.key) {
        collidable.value.onCollisionStart(intersectionPoints);
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    final entries = collidables.entries;
    for (final collidable in entries) {
      if (other.runtimeType == collidable.key) {
        collidable.value.onCollision(intersectionPoints);
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    final entries = collidables.entries;
    for (final collidable in entries) {
      if (other.runtimeType == collidable.key) {
        collidable.value.onCollisionEnd();
      }
    }
  }
}

mixin ExactCollisionHandler<T extends PositionComponent> on CollisionCallbacks {
  Map<dynamic, CollisionBetween<T, dynamic>> exactCollidables = {};

  void mountExactColliables(Map<dynamic, CollisionBetween<T, dynamic>> initial) {
    exactCollidables = initial;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    final entries = exactCollidables.entries;
    for (final collidable in entries) {
      if (other == collidable.value.collided) {
        collidable.value.onCollisionStart(intersectionPoints);
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    final entries = exactCollidables.entries;
    for (final collidable in entries) {
      if (other == collidable.value.collided) {
        collidable.value.onCollision(intersectionPoints);
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    final entries = exactCollidables.entries;
    for (final collidable in entries) {
      if (other == collidable.value.collided) {
        collidable.value.onCollisionEnd();
      }
    }
  }
}
