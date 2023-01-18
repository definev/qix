import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:qix/components/player/components/ball.dart';
import 'package:qix/components/player/components/ball_line.dart';
import 'package:qix/components/utils/collision_between.dart';

class BallLineNBallCollision extends CollisionBetween<BallLine, Ball> {
  BallLineNBallCollision(super.self, super.collided);

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints) {
    if (!collided.collidingWith(self.ancestor)) {
      collided.manager.stop('ball line');
      final first = self.points.first.clone();
      final points = [...self.points, intersectionPoints.first];
      final runningLine = RunnerLine(
        points,
        updatePosition: (center) => collided.center = center,
      );
      runningLine.onDestroy = () {
        collided.center = first;
        self.remove(runningLine);
      };

      self.add(runningLine);
      self.resetLine();
    }
  }
}

class RunnerLine extends Component {
  RunnerLine(
    this.points, {
    required this.updatePosition,
  });

  VoidCallback? onDestroy;
  final Function(Vector2 center) updatePosition;

  final List<Vector2> points;
  late List<Vector2> linePoints = points.map((e) => e.clone()).toList();

  late final polygonLength = points.foldIndexed(
    0.0,
    (index, length, curr) {
      if (index == 0) return length;
      final prev = points[index - 1];
      return length + prev.distanceTo(curr);
    },
  );

  var progress = 0.0;
  final limit = 0.8;

  @override
  int get priority => -1;

  @override
  void update(double dt) {
    progress += dt;
    if (progress > limit) onDestroy?.call();
    if (1 - (progress / limit) < 0) return;

    List<Vector2> currentEdges = [];
    var remainLength = polygonLength * (1 - (progress / limit));
    for (var i = 0; i < points.length - 1; i++) {
      final p1 = points[i].clone();
      final p2 = points[i + 1].clone();
      final edge = (p2 - p1).length;
      remainLength -= edge;
      if (remainLength <= 0) {
        final remainEdge = remainLength + edge;

        if (p1.x == p2.x) {
          if (p1.y < p2.y) {
            p2.y = p1.y + remainEdge;
          } else {
            p2.y = p1.y - remainEdge;
          }
        } else if (p1.y == p2.y) {
          if (p1.x < p2.x) {
            p2.x = p1.x + remainEdge;
          } else {
            p2.x = p1.x - remainEdge;
          }
        }
        currentEdges.addAll([p1, p2]);
        updatePosition(p2);
        break;
      } else {
        if (i == points.length - 1) {
          updatePosition(p2);
        }
        currentEdges.add(p1);
      }
    }

    linePoints = currentEdges;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawPoints(
      PointMode.polygon,
      linePoints.map((e) => e.toOffset()).toList(),
      Paint()
        ..color = Colors.amber.shade100
        ..strokeWidth = 0
        ..strokeCap = StrokeCap.round,
    );
  }
}
