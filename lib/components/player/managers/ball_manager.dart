import 'package:flutter/rendering.dart';

enum BallPosition { playground, boundary, corner, filledArea }

class BallManager {
  BallPosition _ballPosition = BallPosition.boundary;
  BallPosition get position => _ballPosition;
  set position(BallPosition position) {
    debugPrint('Set position to $position');
    _ballPosition = position;
  }

  AxisDirection? direction;

  void stop([String? from]) {
    if (from != null) debugPrint('STOP FROM : $from');
    direction = null;
  }
}
