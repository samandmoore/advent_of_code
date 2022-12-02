import 'dart:io';

void main() {
  final lines = File('input.txt').readAsLinesSync();
  var grid = <int, Map<int, bool>>{};
  final instructions = <Instruction>[];

  final gridLines = lines.takeWhile((line) => line.isNotEmpty);
  final instructionLines = lines.skipWhile((line) => line.isNotEmpty).skip(1);

  for (final line in gridLines) {
    final parts = line.split(',').map((p) => int.parse(p)).toList();
    final x = parts.first;
    final y = parts.last;
    final map = grid[x] ??= {};
    map[y] = true;
  }

  for (final line in instructionLines) {
    final parts = line.split(' ').last.split('=');
    final dimension = parts.first;
    final position = int.parse(parts.last);
    instructions.add(Instruction(dimension: dimension, position: position));
  }

  print(instructions);

  for (final instruction in instructions) {
    final position = instruction.position;

    if (instruction.foldLeft) {
      grid = grid.entries.map((e) {
        final x = e.key;
        final yValues = e.value;

        if (x > position) {
          final diff = x - position;
          final newX = position - diff;
          return MapEntry(newX, yValues);
        } else {
          return MapEntry(x, yValues);
        }
      }).fold({}, (Map<int, Map<int, bool>> previousValue, element) {
        final map = previousValue[element.key] ??= {};
        map.addAll(element.value);
        return previousValue;
      });
    }

    if (instruction.foldUp) {
      grid = grid.map((x, yValues) {
        final newYValues = Map.fromEntries(
          yValues.entries.map((e) {
            final y = e.key;
            if (y > position) {
              final diff = y - position;
              final newY = position - diff;
              return MapEntry(newY, true);
            } else {
              return MapEntry(y, true);
            }
          }),
        );

        return MapEntry(x, newYValues);
      });
    }
  }
  printGrid(grid);
}

void printGrid(Map<int, Map<int, bool>> grid) {
  final maxX = (grid.keys.toList()..sort()).last;
  final maxY =
      (grid.values.expand((element) => element.keys).toList()..sort()).last;
  final xRange = List.generate(maxX + 1, (i) => i % 10);
  final padWidth = maxY.toString().length;

  print('');
  stdout.writeln('${''.padLeft(padWidth)}${xRange.join('')}');
  for (var y = 0; y <= maxY; y++) {
    stdout.write(y.toString().padLeft(padWidth));
    for (var x = 0; x <= maxX; x++) {
      if (grid[x]?[y] == true) {
        stdout.write('#');
      } else {
        stdout.write('.');
      }
    }
    stdout.writeln();
  }
  final visibleDots = grid.entries.fold(
    0,
    (int sum, e) => sum + e.value.values.length,
  );
  print('There are $visibleDots visible dots.');
  print('');
}

class Instruction {
  final String dimension;
  final int position;

  Instruction({
    required this.dimension,
    required this.position,
  });

  bool get foldUp => dimension == 'y';

  bool get foldLeft => dimension == 'x';

  @override
  String toString() {
    return '{dimension: $dimension, position: $position}';
  }
}
