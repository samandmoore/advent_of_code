import 'dart:io';

void main() {
  final rawInput = File('input.txt').readAsStringSync();
  final sortedCrabPositions =
      rawInput.split(',').map((v) => int.parse(v)).toList()..sort();
  final crabsByPosition = <int, int>{};
  final max = sortedCrabPositions.last;

  sortedCrabPositions.forEach((number) {
    if (crabsByPosition.containsKey(number)) {
      crabsByPosition[number] = crabsByPosition[number]! + 1;
    } else {
      crabsByPosition[number] = 1;
    }
  });

  var currentPosition = 0;
  final positionCosts = <int, int>{};

  while (currentPosition <= max) {
    var cost = 0;

    crabsByPosition.entries.forEach((entry) {
      final position = entry.key;
      final numberOfCrabsAtPosition = entry.value;
      cost += (position - currentPosition).abs() * numberOfCrabsAtPosition;
    });

    positionCosts[currentPosition] = cost;
    currentPosition++;
  }

  final sortedPositionCosts = positionCosts.entries.toList()
    ..sort((a, b) => a.value.compareTo(b.value));

  final cheapestPosition = sortedPositionCosts.first;

  print(
      'The cheapest place to move the crabs to is ${cheapestPosition.key} with a cost of ${cheapestPosition.value}');
  print('The positions ranked:');
  print(sortedPositionCosts
      .map((p) => "position: ${p.key}, cost: ${p.value}")
      .join('\n'));
}
