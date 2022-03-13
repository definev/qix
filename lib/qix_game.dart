import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'components/boundary/boundary.dart';
import 'components/player.dart';
import 'helpers/direction.dart';

class QixGame extends FlameGame //
    with
        HasKeyboardHandlerComponents,
        HasCollidables {
  late Player player = Player()..position = initialPlayerPosition;
  var left = BoundaryLeft();
  var right = BoundaryRight();
  var top = BoundaryTop();
  var bottom = BoundaryBottom();

  Vector2 get initialPlayerPosition => Vector2(size.x / 2, size.y - 25);
  Vector2 get playboardSize => size - Vector2(50, 50);

  void onDirectionChange(Direction direction) {
    switch (player.onBoundary) {
      case OnBoundary.left:
        if (direction == Direction.left) {
          player.onBoundary = OnBoundary.none;
          return;
        }
        break;
      case OnBoundary.right:
        if (direction == Direction.right) {
          player.onBoundary = OnBoundary.none;
          return;
        }
        break;
      case OnBoundary.top:
        if (direction == Direction.up) {
          player.onBoundary = OnBoundary.none;
          return;
        }
        break;
      case OnBoundary.bottom:
        if (direction == Direction.down) {
          player.onBoundary = OnBoundary.none;
          return;
        }
        break;
      case OnBoundary.none:
        break;
    }

    if (player.lastDirection == direction.opposite) {
      player.direction = Direction.none;
      return;
    }
    player.direction = direction;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(left);
    add(right);
    add(top);
    add(bottom);
    add(player);
  }
}
