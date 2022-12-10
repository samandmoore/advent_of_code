import 'dart:io';

void main() {
  final lines = File('input-part-1.txt').readAsLinesSync();
  final grid = lines
      .map(
        (l) => l.split('').map((t) => int.parse(t)).toList(),
      )
      .toList();

  var visibleCount = 0;

  for (var y = 0; y < grid.length; y++) {
    for (var x = 0; x < grid[y].length; x++) {
      final cell = cellFor(grid, x, y)!;
      if (cell.isEdge) {
        visibleCount++;
      } else if (cell.isVisible) {
        visibleCount++;
      }
    }
  }

  print(visibleCount);
}

Cell? cellFor(Grid grid, int x, int y) {
  if (x < 0 || y < 0 || y >= grid.length || x >= grid[y].length) {
    return null;
  }
  return Cell(grid: grid, x: x, y: y);
}

typedef Grid = List<List<int>>;

class Cell {
  final Grid grid;
  final int x;
  final int y;

  Cell({required this.grid, required this.x, required this.y});

  Cell? get up {
    return cellFor(grid, x, y - 1);
  }

  Cell? get down {
    return cellFor(grid, x, y + 1);
  }

  Cell? get left {
    return cellFor(grid, x - 1, y);
  }

  Cell? get right {
    return cellFor(grid, x + 1, y);
  }

  List<Cell?> get neighbors {
    return [up, down, left, right];
  }

  bool get isEdge {
    return up == null || down == null || left == null || right == null;
  }

  int get value {
    return grid[y][x];
  }

  bool get isVisible {
    return _determineVisible(this, (cell) => cell?.up) ||
        _determineVisible(this, (cell) => cell?.down) ||
        _determineVisible(this, (cell) => cell?.left) ||
        _determineVisible(this, (cell) => cell?.right);
  }

  bool _determineVisible(Cell? current, Cell? Function(Cell? cell) next) {
    final nextCell = next(current);
    if (nextCell == null) {
      return true;
    }
    return value > nextCell.value && _determineVisible(nextCell, next);
  }
}
