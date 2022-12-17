import 'dart:io';

abstract class Instruction {
  int cyclesLeft;
  Instruction(this.cyclesLeft);

  int Function(int) consumeCycle();

  bool get isComplete => cyclesLeft == 0;
}

class NoopInstruction extends Instruction {
  NoopInstruction() : super(1);

  @override
  int Function(int) consumeCycle() {
    print('noop (start)');
    cyclesLeft--;
    print('noop (end)');
    return (register) => register;
  }
}

class AddInstruction extends Instruction {
  final int argument;
  AddInstruction(this.argument) : super(2);

  @override
  int Function(int) consumeCycle() {
    if (cyclesLeft == 1) {
      print('addx $argument (start)');
    }
    cyclesLeft--;
    if (cyclesLeft == 0) {
      print('addx $argument (end)');
      return (register) => register + argument;
    } else {
      print('addx $argument ($cyclesLeft/2)');
      return (register) => register;
    }
  }
}

void main() {
  final lines = File('input-part-1.txt').readAsLinesSync();
  final instructions = lines.map((line) {
    final parts = line.split(' ');
    final operation = parts[0];
    switch (operation) {
      case 'noop':
        return NoopInstruction();
      case 'addx':
        return AddInstruction(int.parse(parts[1]));
      default:
        throw Exception('Unknown operation: $operation');
    }
  }).toList();

  var spriteCenterIndex = 1;
  final signalStrengths = <int, int>{};
  final crt =
      List<List<int>>.generate(6, (_) => List<int>.generate(40, (_) => 0));
  var row = 0;
  var col = 0;

  Instruction currentInstruction = instructions.removeAt(0);
  int Function(int) nextOperation = (input) => input;

  for (var cycle = 1; cycle <= 240 && instructions.isNotEmpty; cycle++) {
    spriteCenterIndex = nextOperation.call(spriteCenterIndex);
    print('Cycle $cycle start: x = ${spriteCenterIndex}');

    nextOperation = currentInstruction.consumeCycle();

    if (currentInstruction.isComplete) {
      currentInstruction = instructions.removeAt(0);
    }

    if ((cycle ~/ 20).isOdd && cycle % 20 == 0) {
      signalStrengths[cycle] = spriteCenterIndex;
    }

    final spriteStartIndex = spriteCenterIndex - 1;
    final spriteEndIndex = spriteCenterIndex + 1;
    if (col >= spriteStartIndex && col <= spriteEndIndex) {
      crt[row][col] = 1;
    }

    print('Cycle $cycle end: x = ${spriteCenterIndex}');
    if (col < 39) {
      col++;
    } else {
      col = 0;
      row++;
    }
  }

  print(spriteCenterIndex);
  print(signalStrengths);
  print(
    signalStrengths.entries
        .map((e) => e.key * e.value)
        .reduce((value, element) => value + element),
  );
  crt.map((r) => r.map((c) => c == 0 ? '.' : '#').join()).forEach(print);
}
