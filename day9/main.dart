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

  final lowPoints = <Point>[];

  for (var y = 0; y < grid.length; y++) {
    for (var x = 0; x < grid[y].length; x++) {
      final value = grid[y][x];
      final adjacentPoints = getAdjacentPoints(grid: grid, x: x, y: y);
      if (adjacentPoints.every((p) => value < p.value)) {
        lowPoints.add(Point(x: x, y: y, value: value));
      }
    }
  }

  final sumOfLowPoints =
      lowPoints.map((p) => p.value + 1).reduce((sum, value) => sum + value);
  print('The sum of the low points is $sumOfLowPoints');

  final basins = getBasinsForLowPoints(grid, lowPoints);

  final basinsSortedBySize = basins..sort((a, b) => a.size.compareTo(b.size));
  print('The basins sorted by size are:');
  basinsSortedBySize
      .forEach((b) => print('point: ${b.lowPoint}, size: ${b.size}'));
  final productOfLargestBasins = basinsSortedBySize.reversed
      .take(3)
      .map((b) => b.size)
      .reduce((product, value) => product * value);

  print('The product of the 3 largest basins is $productOfLargestBasins');
}

List<Basin> getBasinsForLowPoints(List<List<int>> grid, List<Point> lowPoints) {
  final basins = <Basin>[];

  for (final lowPoint in lowPoints) {
    final basinPoints = <Point>{lowPoint};
    final visited = <Point>{};
    final queue = <Point>[lowPoint];

    while (queue.isNotEmpty) {
      final currentPoint = queue.removeAt(0);
      final adjacentPoints =
          getAdjacentPoints(grid: grid, x: currentPoint.x, y: currentPoint.y);
      for (final point in adjacentPoints) {
        if (visited.contains(point)) continue;
        if (point.value < 9) {
          basinPoints.add(point);
          queue.add(point);
        }
      }
      visited.add(currentPoint);
    }

    basins.add(Basin(lowPoint: lowPoint, points: basinPoints));
  }

  return basins;
}

List<Point> getAdjacentPoints({
  required List<List<int>> grid,
  required int x,
  required int y,
}) {
  return [
    if (y > 0) Point(x: x, y: y - 1, value: grid[y - 1][x]),
    if (y < grid.length - 1) Point(x: x, y: y + 1, value: grid[y + 1][x]),
    if (x > 0) Point(x: x - 1, y: y, value: grid[y][x - 1]),
    if (x < grid.first.length - 1) Point(x: x + 1, y: y, value: grid[y][x + 1]),
  ];
}

class Basin {
  final Point lowPoint;
  final Set<Point> points;

  Basin({required this.lowPoint, required this.points});

  int get size => points.length;
}

class Point {
  final int x;
  final int y;
  final int value;

  Point({required this.x, required this.y, required this.value});

  @override
  bool operator ==(Object? other) {
    return other is Point &&
        x == other.x &&
        y == other.y &&
        value == other.value;
  }

  @override
  int get hashCode => Object.hash(x, y, value);

  @override
  String toString() {
    return '{x:$x, y:$y, value: $value}';
  }
}
