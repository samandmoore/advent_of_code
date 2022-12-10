import 'dart:io';

class Instruction {
  final String direction;
  final int distance;

  Instruction(this.direction, this.distance);

  String toString() => '$direction $distance';
}

class Point {
  final String label;
  final int x;
  final int y;

  Point(this.label, this.x, this.y);

  Point moveUp() {
    return Point(label, x, y + 1);
  }

  Point moveDown() {
    return Point(label, x, y - 1);
  }

  Point moveLeft() {
    return Point(label, x - 1, y);
  }

  Point moveRight() {
    return Point(label, x + 1, y);
  }

  Point moveUpRight() {
    return Point(label, x + 1, y + 1);
  }

  Point moveUpLeft() {
    return Point(label, x - 1, y + 1);
  }

  Point moveDownRight() {
    return Point(label, x + 1, y - 1);
  }

  Point moveDownLeft() {
    return Point(label, x - 1, y - 1);
  }

  List<Point> get neighbors {
    return [
      moveUp(),
      moveDown(),
      moveLeft(),
      moveRight(),
      moveUpRight(),
      moveUpLeft(),
      moveDownRight(),
      moveDownLeft(),
    ];
  }

  bool isAdjacent(Point other) {
    // get all adjacent points
    // return true if other is in the list
    if (this == other) {
      return true;
    }

    if (neighbors.contains(other)) {
      return true;
    }

    return false;
  }

  String toString() => '$label ($x, $y)';

  bool operator ==(Object other) {
    if (other is Point) {
      return other.x == x && other.y == y;
    }
    return false;
  }

  int get hashCode => x.hashCode ^ y.hashCode;
}

void main() {
  final lines = File('input-part-1.txt').readAsLinesSync();
  final instructions = lines.map((line) {
    final parts = line.split(' ');
    final direction = parts[0];
    final distance = int.parse(parts[1]);
    return Instruction(direction, distance);
  }).toList();

  final knots = List<Point>.generate(10, (index) => Point('$index', 0, 0));
  final tailVisited = <Point>{};
  tailVisited.add(knots.last);

  instructions.forEach((instruction) {
    print(instruction);
    for (var i = 0; i < instruction.distance; i++) {
      switch (instruction.direction) {
        case 'U':
          knots[0] = knots[0].moveUp();
          break;
        case 'D':
          knots[0] = knots[0].moveDown();
          break;
        case 'L':
          knots[0] = knots[0].moveLeft();
          break;
        case 'R':
          knots[0] = knots[0].moveRight();
          break;
      }
      print(knots[0]);
      for (var knotI = 1; knotI < knots.length; knotI++) {
        final head = knots[knotI - 1];
        final tail = knots[knotI];
        knots[knotI] = checkAndUpdateTail(head, tail);
        print(knots[knotI]);
      }
      tailVisited.add(knots.last);
    }
  });

  print(tailVisited.length);
}

Point checkAndUpdateTail(Point head, Point tail) {
  if (head.isAdjacent(tail)) {
    return tail;
  } else if (tail.moveDown().moveDown() == head) {
    return tail.moveDown();
  } else if (tail.moveUp().moveUp() == head) {
    return tail.moveUp();
  } else if (tail.moveLeft().moveLeft() == head) {
    return tail.moveLeft();
  } else if (tail.moveRight().moveRight() == head) {
    return tail.moveRight();
  } else if (head.x > tail.x && head.y > tail.y) {
    return tail.moveUpRight();
  } else if (head.x < tail.x && head.y > tail.y) {
    return tail.moveUpLeft();
  } else if (head.x > tail.x && head.y < tail.y) {
    return tail.moveDownRight();
  } else if (head.x < tail.x && head.y < tail.y) {
    return tail.moveDownLeft();
  } else {
    return tail;
  }
}
