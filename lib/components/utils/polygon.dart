import 'package:flame/extensions.dart';

class PolygonUtils {
  static double calculateArea(List<Vector2> vertices) {
    int n = vertices.length;
    double area = 0;
    for (int i = 0; i < n; i++) {
      int j = (i + 1) % n;
      area += vertices[i].x * vertices[j].y;
      area -= vertices[j].x * vertices[i].y;
    }
    return area.abs() / 2;
  }
}
