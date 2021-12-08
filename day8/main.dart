import 'dart:io';

void main() {
  final rawLines = File('input.txt').readAsLinesSync();
  final signals = <List<String>>[];
  final outputs = <List<String>>[];

  rawLines.forEach((l) {
    final parts = l.split('|');
    signals.add(parts.first.trim().split(' '));
    outputs.add(parts.last.trim().split(' '));
  });

  var oneFourSevenOrEights = 0;

  outputs.forEach((outputLine) {
    outputLine.forEach((output) {
      final lengths = [
        numberToSignals[1],
        numberToSignals[4],
        numberToSignals[7],
        numberToSignals[8],
      ].map((v) => v!.length);
      if (lengths.contains(output.length)) {
        oneFourSevenOrEights++;
      }
    });
  });

  print('There are $oneFourSevenOrEights 1s, 4s, 7s, or 8s.');
}

final numberToSignals = <int, String>{
  0: 'abcefg',
  1: 'cf',
  2: 'acdeg',
  3: 'acdfg',
  4: 'bcdf',
  5: 'abdfg',
  6: 'abdefg',
  7: 'acf',
  8: 'abcdefg',
  9: 'abcdfg',
};
