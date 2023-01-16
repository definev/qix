import 'package:flame/extensions.dart';

class PolygonUtils {
  static double calculateArea(List<Vector2> polygonVertices) {
    double area = 0.0;
    for (int i = 0; i < polygonVertices.length - 1; i++) {
      Vector2 v1 = polygonVertices[i];
      Vector2 v2 = polygonVertices[i + 1];
      area += v1.cross(v2).abs();
    }
    area = area.abs() / 2;
    return area;
  }
}
