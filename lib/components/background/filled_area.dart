import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class FilledArea extends PositionComponent {
  FilledArea({super.children});

  final List<List<Vector2>> _areas = [];
  final List<List<Offset>> _rawAreas = [];
  List<Color> colors = [];
  final rand = Random();

  void addArea(List<Vector2> area) {
    colors.add(Color.fromRGBO(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255), 1));
    _areas.add(area);
    _rawAreas.add(area.map((p) => p.toOffset()).toList());
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
        ..strokeWidth = 2,
    );
  }
}
