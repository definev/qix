enum Direction {
  up,
  down,
  left,
  right,
  none,
}

extension OppositeDirection on Direction {
  Direction? get opposite => {
        Direction.up: Direction.down,
        Direction.down: Direction.up,
        Direction.left: Direction.right,
        Direction.right: Direction.left,
      }[this];
}
