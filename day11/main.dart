import 'dart:collection';
import 'dart:io';

void main() {
  final lines = File('input.txt').readAsLinesSync();
  final grid = parseLinesToGrid(lines);

  int flashed = 0;
  var numberOfIterations = 0;
  while (flashed < 100) {
    numberOfIterations++;
    flashed = runIteration(grid);
  }

  print('All of them flashed at step: ${numberOfIterations}');
}

int runIteration(Grid grid) {
  final needsFlash = LinkedHashSet<Point>();
  for (var y = 0; y < grid.length; y++) {
    for (var x = 0; x < grid[y].length; x++) {
      final point = grid[y][x];
      final value = ++point.value;

      if (value > 9) {
        needsFlash.add(point);
      }
    }
  }

  final flashed = <Point>{};
  while (needsFlash.isNotEmpty) {
    final point = needsFlash.first;
    flashed.add(point);

    final adjacents = getAdjacents(grid, point);
    for (final adjacent in adjacents) {
      if (adjacent.value > 9) continue;
      adjacent.value++;

      if (adjacent.value > 9) {
        needsFlash.add(adjacent);
      }
    }

    needsFlash.remove(point);
  }

  flashed.forEach((p) => p.value = 0);

  return flashed.length;
}

Grid parseLinesToGrid(List<String> lines) {
  final results = Grid.empty(growable: true);

  for (var lineNumber = 0; lineNumber < lines.length; lineNumber++) {
    final pointsInLine = <Point>[];
    final digits = lines[lineNumber].split('');

    for (var position = 0; position < digits.length; position++) {
      final value = int.parse(digits[position]);
      pointsInLine.add(Point(y: lineNumber, x: position, value: value));
    }

    results.add(pointsInLine);
  }

  return results;
}

List<Point> getAdjacents(Grid grid, Point point) {
  return [
    if (point.x > 0) grid[point.y][point.x - 1],
    if (point.x > 0 && point.y > 0) grid[point.y - 1][point.x - 1],
    if (point.y > 0) grid[point.y - 1][point.x],
    if (point.y > 0 && point.x < grid[0].length - 1)
      grid[point.y - 1][point.x + 1],
    if (point.x < grid[0].length - 1) grid[point.y][point.x + 1],
    if (point.y < grid.length - 1 && point.x < grid[0].length - 1)
      grid[point.y + 1][point.x + 1],
    if (point.y < grid.length - 1) grid[point.y + 1][point.x],
    if (point.y < grid.length - 1 && point.x > 0)
      grid[point.y + 1][point.x - 1],
  ];
}

typedef Grid = List<List<Point>>;

class Point {
  final int x;
  final int y;
  int value;

  Point({
    required this.x,
    required this.y,
    required this.value,
  });

  @override
  int get hashCode => Object.hash(x, y, value);

  @override
  bool operator ==(Object? other) {
    return other is Point &&
        x == other.x &&
        y == other.y &&
        value == other.value;
  }
}
