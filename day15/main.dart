import 'dart:io';

import 'package:collection/collection.dart';

typedef Grid = List<List<Vertex>>;

void main() {
  final grid = File('input.txt')
      .readAsLinesSync()
      .mapIndexed(
        (y, line) => line
            .split('')
            .mapIndexed(
              (x, weight) => Vertex(
                point: Point(x: x, y: y),
                weight: int.parse(weight),
              ),
            )
            .toList(),
      )
      .toList();

  final distances = <Point, int>{};
  final q = PriorityQueue<Vertex>((a, b) => a.weight.compareTo(b.weight));
  final startVertex = grid.first.first;
  distances[startVertex.point] = 0;
  q.add(Vertex(point: startVertex.point, weight: 0));

  while (q.isNotEmpty) {
    final current = q.removeFirst();

    final adjacents = getAdjacentVerticies(current, grid);

    for (final adjacent in adjacents) {
      final distanceToCurrent = distances[current.point];
      final distanceToAdjacent = distances[adjacent.point];

      if (distanceToAdjacent == null ||
          (distanceToCurrent != null &&
              distanceToCurrent + adjacent.weight < distanceToAdjacent)) {
        distances[adjacent.point] = distanceToCurrent! + adjacent.weight;
        q.add(Vertex(
          point: adjacent.point,
          weight: distances[adjacent.point]!,
        ));
      }
    }
  }

  final destination = grid.last.last;
  print(
      'Shortest path distance to $destination is ${distances[destination.point]}');
}

List<Vertex> getAdjacentVerticies(Vertex vertex, Grid grid) {
  final y = vertex.point.y;
  final x = vertex.point.x;

  return [
    if (y > 0) grid[y - 1][x],
    if (y < grid.length - 1) grid[y + 1][x],
    if (x > 0) grid[y][x - 1],
    if (x < grid.first.length - 1) grid[y][x + 1],
  ];
}

class Vertex {
  final Point point;
  final int weight;

  Vertex({required this.point, required this.weight});

  @override
  int get hashCode => Object.hash(point, weight);

  @override
  bool operator ==(Object? other) =>
      other is Vertex && point == other.point && weight == other.weight;

  @override
  String toString() => '{point: $point, weight: $weight}';
}

class Point {
  final int x;
  final int y;

  Point({required this.x, required this.y});

  @override
  int get hashCode => Object.hash(x, y);

  @override
  bool operator ==(Object? other) =>
      other is Point && x == other.x && y == other.y;

  @override
  String toString() => '{$x,$y}';
}
