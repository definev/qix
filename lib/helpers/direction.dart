import 'package:freezed_annotation/freezed_annotation.dart';

part 'direction.freezed.dart';

@freezed
class Direction with _$Direction {
  const factory Direction.up() = DirectionUp;
  const factory Direction.down() = DirectionDown;
  const factory Direction.left() = DirectionLeft;
  const factory Direction.right() = DirectionRight;
  const factory Direction.none([Direction? boundaryDirection]) = DirectionNone;
}

extension OppositeDirection on Direction {
  Direction? get opposite => mapOrNull(
        up: (_) => const Direction.down(),
        down: (_) => const Direction.up(),
        left: (_) => const Direction.right(),
        right: (_) => const Direction.left(),
      );
}
