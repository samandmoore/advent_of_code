import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final lines = File('input.txt').readAsLinesSync();
  final template = lines.first.split('').toList();
  final rules = Map.fromEntries(
    lines.skip(2).map((line) {
      final parts = line.split(' -> ');
      return MapEntry(parts[0], parts[1]);
    }),
  );

  final elementCount = template.groupFoldBy<String, int>(
      (element) => element, (int? previous, _) => (previous ?? 0) + 1);

  var pairCount = <Pair, int>{};
  for (var i = 0; i < template.length; i++) {
    if (i + 1 == template.length) continue;
    final pair = Pair(template[i], template[i + 1]);
    final count = pairCount[pair] ??= 0;
    pairCount[pair] = count + 1;
  }

  final maxIterations = 40;
  var iteration = 0;
  while (iteration < maxIterations) {
    iteration++;
    final newPairCount = <Pair, int>{};
    pairCount.entries.forEach((entry) {
      final pair = entry.key;
      final countForThisPair = entry.value;
      final newElement = rules[pair.combined]!;

      final existingElementCount = elementCount[newElement] ??= 0;
      elementCount[newElement] = existingElementCount + countForThisPair;

      final newPairA = Pair(pair.a, newElement);
      final aCount = newPairCount[newPairA] ??= 0;
      newPairCount[newPairA] = aCount + countForThisPair;

      final newPairB = Pair(newElement, pair.b);
      final bCount = newPairCount[newPairB] ??= 0;
      newPairCount[newPairB] = bCount + countForThisPair;
    });
    pairCount = newPairCount;
    print('After iteration $iteration');
  }

  final sortedCounts = elementCount.values.toList()..sort();
  final score = sortedCounts.last - sortedCounts.first;
  print('Score: $score');
}

class Pair {
  final String a;
  final String b;

  Pair(this.a, this.b);

  String get combined => "$a$b";

  @override
  String toString() => "$a$b";

  @override
  int get hashCode => Object.hash(a, b);

  @override
  bool operator ==(Object? other) {
    return other is Pair && a == other.a && b == other.b;
  }
}
