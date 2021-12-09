import 'dart:io';

typedef Signal = Set<String>;

class Line {
  final List<Signal> inputs;
  final List<Signal> outputs;

  Line({required this.inputs, required this.outputs});
}

void main() {
  final rawLines = File('input.txt').readAsLinesSync();
  final lines = rawLines.map((l) {
    final parts = l.split('|');

    final rawInputs = parts.first.trim().split(' ');
    final inputs = rawInputs.map((s) => s.split('').toSet()).toList();

    final rawOutputs = parts.last.trim().split(' ');
    final outputs = rawOutputs.map((s) => s.split('').toSet()).toList();

    return Line(inputs: inputs, outputs: outputs);
  });

  final outputValues = <int>[];

  for (final line in lines) {
    final inputs = List.of(line.inputs);

    // cf
    final one = inputs.removeAt(inputs.indexWhere((s) => s.length == 2));

    // acf
    final seven = inputs.removeAt(inputs.indexWhere((s) => s.length == 3));

    // bcdf
    final four = inputs.removeAt(inputs.indexWhere((s) => s.length == 4));

    // abcdefg
    final eight = inputs.removeAt(inputs.indexWhere((s) => s.length == 7));

    final zeroSixNine = inputs.where((s) => s.length == 6).toList();

    // abcdfg
    final nine = zeroSixNine.singleWhere((s) => s.difference(four).length == 2);
    inputs.remove(nine);
    zeroSixNine.remove(nine);

    // six
    final six = zeroSixNine.singleWhere((s) => s.difference(one).length == 5);
    inputs.remove(six);
    zeroSixNine.remove(six);

    // zero
    final zero = zeroSixNine.singleWhere((s) => s.difference(one).length == 4);
    inputs.remove(zero);
    zeroSixNine.remove(zero);

    final twoThreeFive = inputs;

    // three
    final three =
        twoThreeFive.singleWhere((s) => s.difference(one).length == 3);
    inputs.remove(three);
    twoThreeFive.remove(three);

    // two
    final two = twoThreeFive.singleWhere((s) => s.difference(six).length == 1);
    inputs.remove(two);
    twoThreeFive.remove(two);

    // five
    final five = twoThreeFive.first;

    final setToString = (Set<String> set) => (set.toList()..sort()).join('');

    final numberToSignal = <String, String>{
      setToString(zero): '0',
      setToString(one): '1',
      setToString(two): '2',
      setToString(three): '3',
      setToString(four): '4',
      setToString(five): '5',
      setToString(six): '6',
      setToString(seven): '7',
      setToString(eight): '8',
      setToString(nine): '9',
    };

    final outputs = line.outputs;
    final outputValueString = outputs.map((o) {
      final value = numberToSignal[setToString(o)];
      return value;
    }).join('');
    outputValues.add(int.parse(outputValueString));
  }

  print('Sum of output values is: ${outputValues.reduce((sum, v) => sum + v)}');
}
