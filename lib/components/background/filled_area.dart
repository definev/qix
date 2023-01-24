import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:qix/components/background/boundary.dart';
import 'package:qix/components/utils/debug_color.dart';
import 'package:qix/components/utils/game_utils.dart';
import 'package:qix/components/utils/line_hit_box.dart';
import 'package:qix/components/utils/priority.dart';
import 'package:qix/main.dart';

class FilledArea extends PositionComponent with HasGameReference<QixGame> {
  FilledArea({super.children});

  Boundary get boundary => game.firstChild()!;

  @override
  int get priority => GamePriority.filledArea;

  final List<List<Vector2>> _areas = [];
  final List<List<Offset>> _rawAreas = [];
  List<Color> colors = [];
  final rand = Random();

  final List<LineHitBox> _hitBoxes = [];

  void addArea(List<Vector2> area) {
    colors.add(Color.fromRGBO(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255), 1));
    _areas.add(area);
    _rawAreas.add(area.map((p) => p.toOffset()).toList());

    for (var i = 0; i < area.length - 1; i++) {
      final hitBox = LineHitBox.create(
        from: area[i],
        to: area[i + 1],
      )..debugColor = DebugColors.filledArea;
      _hitBoxes.add(hitBox);
      add(hitBox);
    }
  }

  @override
  void render(Canvas canvas) {
    for (int index = _areas.length - 1; index >= 0; index--) {
      drawArea(canvas, index);
    }
  }

  void drawArea(Canvas canvas, int index) {
    final area = _areas[index];
    final rawArea = _rawAreas[index];
    final iter = area.iterator;
    iter.moveNext();
    final path = Path()..moveTo(iter.current.x, iter.current.y);

    while (iter.moveNext()) {
      path.lineTo(iter.current.x, iter.current.y);
    }

    canvas.drawPath(path, Paint()..color = colors[index]);
    canvas.drawPoints(
      PointMode.polygon,
      rawArea,
      Paint()
        ..color = Colors.white
        ..strokeCap = StrokeCap.round
        ..strokeWidth = GameUtils.thickness,
    );
  }
}

extension GetFilledArea on HasGameReference<QixGame> {
  FilledArea get filledArea => game.firstChild()!;
}
