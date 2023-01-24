import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

abstract class CollisionBetween<S extends PositionComponent, O extends PositionComponent> {
  final S self;
  final O collided;

  bool debugMode = false;

  CollisionBetween(this.self, this.collided);

  void _onCollision(Set<Vector2> intersectionPoints) {
    if (debugMode) debugPrint('$S-$O: onCollision');
    onCollision(intersectionPoints);
  }

  void onCollision(Set<Vector2> intersectionPoints) {}

  void _onCollisionStart(Set<Vector2> intersectionPoints) {
    if (debugMode) debugPrint('$S-$O: onCollisionStart');
    onCollisionStart(intersectionPoints);
  }

  void onCollisionStart(Set<Vector2> intersectionPoints) {}

  void _onCollisionEnd() {
    if (debugMode) debugPrint('$S-$O: onCollisionEnd');
    onCollisionEnd();
  }

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
        collidable.value._onCollisionStart(intersectionPoints);
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    final entries = collidables.entries;
    for (final collidable in entries) {
      if (other.runtimeType == collidable.key) {
        collidable.value._onCollision(intersectionPoints);
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    final entries = collidables.entries;
    for (final collidable in entries) {
      if (other.runtimeType == collidable.key) {
        collidable.value._onCollisionEnd();
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
