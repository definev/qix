import 'package:flame/components.dart';

mixin HasManager<T> on Component {
  late T manager;
}
