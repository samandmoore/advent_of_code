import 'dart:io';
import 'dart:math';

void main() {
  final lines = File('input.txt').readAsLinesSync();
  final parseRange = (String rangeString) {
    final parts = rangeString.split('=').last.split('..').map(
          (x) => int.parse(x),
        );
    return Range(min: parts.first, max: parts.last);
  };
  final instructions = lines.map((line) {
    final parts = line.split(' ');
    final on = parts.first == 'on';
    final ranges = parts.last.split(',');
    final x = parseRange(ranges[0]);
    final y = parseRange(ranges[1]);
    final z = parseRange(ranges[2]);
    return Instruction(
      on: on,
      x: x,
      y: y,
      z: z,
    );
  });
  print(instructions.join('\n'));

  partOne(instructions);
  partTwo(instructions);
}

void partTwo(Iterable<Instruction> instructions) {
  final filled = <Instruction>[];
  for (final instruction in instructions) {
    final toAdd = <Instruction>[];
    if (instruction.on) {
      toAdd.add(instruction);
    }
    for (var f in filled) {
      final intersection = f.findIntersection(instruction);
      if (intersection != null) {
        toAdd.add(intersection);
      }
    }
    filled.addAll(toAdd);
  }

  final enabledCubeCount = filled
      .map((i) => i.cubeCount * (i.on ? 1 : -1))
      .fold(0, (int sum, value) => sum + value);

  print(enabledCubeCount);
}

void partOne(Iterable<Instruction> instructions) {
  final withinInitArea = instructions.where(
    (i) =>
        rangeWithinInitArea(i.x) &&
        rangeWithinInitArea(i.y) &&
        rangeWithinInitArea(i.z),
  );

  print(withinInitArea.join('\n'));

  final enabledCubes = <Cube>{};
  for (final instruction in withinInitArea) {
    final cubes = instruction.buildCubes().toList();
    if (instruction.on) {
      enabledCubes.addAll(cubes);
    } else {
      enabledCubes.removeAll(cubes);
    }
  }

  print(enabledCubes.length);
}

bool rangeWithinInitArea(Range r) {
  return r.min >= -50 && r.max <= 50;
}

class Cube {
  final int x;
  final int y;
  final int z;

  Cube({
    required this.x,
    required this.y,
    required this.z,
  });

  @override
  String toString() => '$x,$y,$z';

  @override
  int get hashCode => Object.hash(x, y, z);

  @override
  bool operator ==(Object? other) =>
      other is Cube && x == other.x && y == other.y && z == other.z;
}

class Instruction {
  final bool on;
  final Range x;
  final Range y;
  final Range z;

  Instruction({
    required this.on,
    required this.x,
    required this.y,
    required this.z,
  });

  int get cubeCount {
    return (x.max - x.min + 1) * (y.max - y.min + 1) * (z.max - z.min + 1);
  }

  @override
  String toString() {
    return 'on x=$x,y=$y,z=$z';
  }

  Iterable<Cube> buildCubes() sync* {
    for (var currentX = x.min; currentX <= x.max; currentX++) {
      for (var currentY = y.min; currentY <= y.max; currentY++) {
        for (var currentZ = z.min; currentZ <= z.max; currentZ++) {
          yield Cube(x: currentX, y: currentY, z: currentZ);
        }
      }
    }
  }

  Instruction? findIntersection(Instruction other) {
    if (x.min <= other.x.max &&
        x.max >= other.x.min &&
        y.min <= other.y.max &&
        y.max >= other.y.min &&
        z.min <= other.z.max &&
        z.max >= other.z.min) {
      return Instruction(
        on: !on,
        x: Range(min: max(x.min, other.x.min), max: min(x.max, other.x.max)),
        y: Range(min: max(y.min, other.y.min), max: min(y.max, other.y.max)),
        z: Range(min: max(z.min, other.z.min), max: min(z.max, other.z.max)),
      );
    }

    return null;
  }
}

class Range {
  final int min;
  final int max;

  Range({
    required this.min,
    required this.max,
  });

  @override
  String toString() {
    return '$min..$max';
  }
}
