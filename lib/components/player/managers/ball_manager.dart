import 'package:flutter/rendering.dart';

enum BallPosition { playground, boundary, corner }

class BallManager {
  BallPosition ballPosition = BallPosition.boundary;

  AxisDirection? direction;

  void stop([String? from]) {
    if (from != null) debugPrint('STOP FROM : $from');
    direction = null;
  }
}
