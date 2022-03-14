import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'components/boundary/boundary.dart';
import 'components/boundary/on_boundary.dart';
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

  bool _isOutOfBound(Direction direction, Boundary boundary) {
    return boundary.map(
      left: (_) {
        if (direction == const Direction.left()) {
          return true;
        }
        return false;
      },
      right: (_) {
        if (direction == const Direction.right()) {
          return true;
        }
        return false;
      },
      top: (_) {
        if (direction == const Direction.up()) {
          return true;
        }
        return false;
      },
      bottom: (_) {
        if (direction == const Direction.down()) {
          return true;
        }
        return false;
      },
      none: (dir) {
        return false;
      },
    );
  }

  bool isOutOfBounds(Direction direction) {
    for (final boundary in player.collidedBoundarySet) {
      bool isOut = _isOutOfBound(direction, boundary);
      if (isOut) return true;
    }
    return false;
  }

  bool isOppositeDirection(Direction direction) {
    return player.lastDirection == direction.opposite;
  }

  void onDirectionChange(Direction direction) {
    if (isOutOfBounds(direction)) return;
    if (isOppositeDirection(direction)) {
      player.direction = const Direction.none();
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
