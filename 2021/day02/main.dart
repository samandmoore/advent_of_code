import 'dart:io';

void main() {
  final rawInstructions = File('input.txt').readAsLinesSync();
  var depth = 0;
  var horizontalPosition = 0;
  var aim = 0;

  for (final rawInstruction in rawInstructions) {
    final parts = rawInstruction.split(' ');
    final instruction = parts[0];
    final changeAmount = int.parse(parts[1]);

    switch (instruction) {
      case 'forward':
        horizontalPosition += changeAmount;
        depth += aim * changeAmount;
        break;
      case 'up':
        aim -= changeAmount;
        break;
      case 'down':
        aim += changeAmount;
        break;
    }
  }

  print("Horizontal position * depth = ${horizontalPosition * depth}");
}
