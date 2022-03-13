import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'components/boundary/boundary.dart';
import 'components/player.dart';
import 'helpers/direction.dart';

class QixGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollidables {
  late Player player = Player()..position = Vector2(size.x / 2, size.y - 25);
  var left = BoundaryLeft();
  var right = BoundaryRight();
  var top = BoundaryTop();
  var bottom = BoundaryBottom();

  void onDirectionChange(Direction direction) {
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
