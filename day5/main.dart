import 'dart:io';

void main() {
  final rawLines = File('input.txt').readAsLinesSync();
  final lines = parseLines(rawLines);

  final points = <Point, int>{};

  lines
      .where(
        (l) => l.isHorizontal || l.isVertical,
      )
      .forEach(
        (l) => l.points.forEach((p) {
          if (points.containsKey(p)) {
            points[p] = points[p]! + 1;
          } else {
            points[p] = 1;
          }
        }),
      );

  final numberOfPointsWithTwoOrMore =
      points.entries.where((entry) => entry.value > 1).length;

  print('There are $numberOfPointsWithTwoOrMore with 2 or more hits');
}

List<Line> parseLines(List<String> rawLines) {
  return rawLines.map((l) {
    final rawPoints = l.split('->').map((p) => p.trim());
    final startParts = rawPoints.first.split(',').map((v) => int.parse(v));
    final endParts = rawPoints.last.split(',').map((v) => int.parse(v));
    return Line(
      start: Point(x: startParts.first, y: startParts.last),
      end: Point(x: endParts.first, y: endParts.last),
    );
  }).toList();
}

class Point {
  final int x;
  final int y;

  Point({required this.x, required this.y});

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Point &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y));
  }

  @override
  int get hashCode {
    return Object.hash(x, y);
  }

  @override
  String toString() {
    return '{x: $x, y: $y}';
  }
}

class Line {
  final Point start;
  final Point end;

  Line({required this.start, required this.end});

  bool get isVertical => start.x == end.x;

  bool get isHorizontal => start.y == end.y;

  List<Point> get points {
    final points = <Point>[];
    if (isVertical) {
      final diff = end.y - start.y;
      final length = diff.abs();
      for (var i = 0; i <= length; i++) {
        points.add(
          Point(
            x: start.x,
            y: start.y + (diff.sign * i),
          ),
        );
      }
    } else if (isHorizontal) {
      final diff = end.x - start.x;
      final length = diff.abs();
      for (var i = 0; i <= length; i++) {
        points.add(
          Point(
            x: start.x + (diff.sign * i),
            y: start.y,
          ),
        );
      }
    }
    return points;
  }

  @override
  String toString() {
    return '{start: $start, end: $end}';
  }
}
