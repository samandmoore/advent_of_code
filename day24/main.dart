import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final monadProgram = File('monad.txt').readAsLinesSync();
  final groups = monadProgram.splitBefore((i) => i.startsWith('inp')).toList();

  var w = 9;
  var zIn = -1;
  var zOut = -1;
  late Alu alu;
  while (zOut != 0) {
    zIn++;

    alu = Alu(
      input: '${w}99',
      w: 0,
      x: 0,
      y: 0,
      z: zIn,
    );

    alu.applyAll(groups[groups.length - 3]);
    alu.applyAll(groups[groups.length - 2]);
    alu.applyAll(groups[groups.length - 1]);
    zOut = alu.z;
  }
  print('w=$w,zIn=$zIn produces $alu');

  // // add z y
  // // z = z + y
  // // 0 = -y + y
  // // z = 0
  // // w = 9

  // for (var digit in List.generate(9, (i) => (i + 1).toString()).reversed) {
  //   final w = 0;
  //   final x = 0;
  //   final y = 0;
  //   final z = 0;
  //   final groupsToProcess = 14;
  //   final alu = Alu(
  //     input: ''.padLeft(groupsToProcess, digit),
  //     w: w,
  //     x: x,
  //     y: y,
  //     z: z,
  //   );

  //   for (final group in groups.take(groupsToProcess)) {
  //     for (var instruction in group) {
  //       alu.apply(instruction);
  //     }
  //   }
  //   print(alu);
  // }

  // last stanza
  // w = ?
  // x = z
  // x = (((z / 26) - 4) == w) == 0)
  // y = ((0 + 25) * x) + 1
  // z = (z / 26) * y
  // y = (w + 11) * x
  // z = z + y

  // inputs to each stanza
  // w is always your input
  // x is always 1
  // y is always 0'd out before it's used
  // z is the value from the previous stanza

  // final combined = runProgram(
  //     groups.expand((g) => g).toList(), ''.padLeft(groups.length, digit));
  // print(combined);

  // final monadProgram = File('monad.txt').readAsStringSync();

  // var modelNumber = 99999999999999;
  // while (modelNumber >= 11111111111111) {
  //   print('testing model number $modelNumber');
  //   final monadResult = runProgram(monadProgram, modelNumber.toString());
  //   if (monadResult.z == 0) {
  //     print('valid number found: $modelNumber');
  //     break;
  //   }
  //   modelNumber--;
  //   while (modelNumber.toString().contains('0')) {
  //     modelNumber--;
  //   }
  // }
}

Alu runProgram(Object programCode, String inputStream) {
  List<String> instructions;
  if (programCode is String) {
    instructions = programCode.trim().split('\n');
  } else {
    instructions = programCode as List<String>;
  }

  final alu = Alu(input: inputStream);
  for (var instruction in instructions) {
    alu.apply(instruction);
  }

  return alu;
}

class Alu {
  static const wKey = 'w';
  static const xKey = 'x';
  static const yKey = 'y';
  static const zKey = 'z';
  final Map<String, int> values;

  int get w => values[wKey]!;
  int get x => values[xKey]!;
  int get y => values[yKey]!;
  int get z => values[zKey]!;

  final String input;
  int inputPosition = 0;

  Alu({
    required this.input,
    int? w,
    int? x,
    int? y,
    int? z,
  }) : values = {
          wKey: w ?? 0,
          xKey: x ?? 0,
          yKey: y ?? 0,
          zKey: z ?? 0,
        };

  void applyAll(List<String> instructions) {
    instructions.forEach((i) => apply(i));
  }

  void apply(String instruction) {
    final parts = instruction.split(' ');
    final opCode = parts.removeAt(0);

    switch (opCode) {
      case 'inp':
        final a = parts.first;
        writeValue(a, readNextInputValue());
        break;
      case 'add':
        final a = parts.first;
        final b = parts.last;
        writeValue(a, readValueOrLiteral(a) + readValueOrLiteral(b));
        break;
      case 'mul':
        final a = parts.first;
        final b = parts.last;
        writeValue(a, readValueOrLiteral(a) * readValueOrLiteral(b));
        break;
      case 'div':
        final a = parts.first;
        final b = parts.last;
        writeValue(a, (readValueOrLiteral(a) / readValueOrLiteral(b)).floor());
        break;
      case 'mod':
        final a = parts.first;
        final b = parts.last;
        writeValue(a, readValueOrLiteral(a) % readValueOrLiteral(b));
        break;
      case 'eql':
        final a = parts.first;
        final b = parts.last;
        writeValue(a, readValueOrLiteral(a) == readValueOrLiteral(b) ? 1 : 0);
        break;
    }
  }

  int readValueOrLiteral(String nameOrLiteral) {
    return values[nameOrLiteral] ?? int.parse(nameOrLiteral);
  }

  void writeValue(String name, value) {
    values[name] = value;
  }

  int readNextInputValue() {
    final value = int.parse(currentInputValue);
    incrementInputPosition();
    return value;
  }

  String get currentInputValue => input[inputPosition];

  void incrementInputPosition() {
    inputPosition++;
  }

  @override
  String toString() {
    return '$values';
  }
}
