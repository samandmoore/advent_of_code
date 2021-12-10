import 'dart:io';

void main() {
  final rawLines = File('input.txt').readAsLinesSync();
  final grid = rawLines
      .map(
        (l) => l
            .split('')
            .map(
              (n) => int.parse(n),
            )
            .toList(),
      )
      .toList();

  final lowPoints = <int>[];

  for (var y = 0; y < grid.length; y++) {
    for (var x = 0; x < grid[y].length; x++) {
      final value = grid[y][x];
      final adjacentPoints = getAdjacentPoints(allPoints: grid, x: x, y: y);
      if (adjacentPoints.every((p) => value < p)) {
        lowPoints.add(value);
      }
    }
  }

  final sumOfLowPoints =
      lowPoints.map((p) => p + 1).reduce((sum, value) => sum + value);
  print('The sum of the low points is $sumOfLowPoints');
}

List<int> getAdjacentPoints({
  required List<List<int>> allPoints,
  required int x,
  required int y,
}) {
  return [
    if (y > 0) allPoints[y - 1][x],
    if (y < allPoints.length - 1) allPoints[y + 1][x],
    if (x > 0) allPoints[y][x - 1],
    if (x < allPoints.first.length - 1) allPoints[y][x + 1],
  ];
}
