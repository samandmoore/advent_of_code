import 'dart:io';

class Instruction {
  Instruction();
}

class NoopInstruction extends Instruction {
  NoopInstruction();
}

class AddInstruction extends Instruction {
  final int argument;
  AddInstruction(this.argument);
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
  var register = 1;
  var cycle = 1;
  final signalStrengths = <int, int>{};
  final increaseCycle = () {
    cycle += 1;
    print('Cycle $cycle: x = ${register}');
  };

  final captureRegisterValue = () {
    if ((cycle ~/ 20).isOdd && cycle % 20 == 0) {
      signalStrengths[cycle] = register;
    }
  };

  instructions.forEach((ins) {
    if (ins is NoopInstruction) {
      print('Cycle $cycle: noop (start)');
      captureRegisterValue();
      increaseCycle();
      captureRegisterValue();
      print('Cycle $cycle: noop (end)');
    } else if (ins is AddInstruction) {
      print('Cycle $cycle: addx ${ins.argument} (start)');
      captureRegisterValue();
      increaseCycle();
      captureRegisterValue();
      increaseCycle();
      register += ins.argument;
      captureRegisterValue();
      print('Cycle $cycle: addx ${ins.argument} (end)');
    }
  });
  print(register);
  print(signalStrengths);
  print(
    signalStrengths.entries
        .map((e) => e.key * e.value)
        .reduce((value, element) => value + element),
  );
}
