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

  final maxIterations = 40;
  var iteration = 0;
  var currentTemplate = List.of(template);
  while (iteration < maxIterations) {
    iteration++;
    currentTemplate = runIteration(currentTemplate, rules);
    print('After iteration $iteration');
  }

  final score = mostCommonMinusLeastCommon(currentTemplate);
  print('Score: $score');
}

int mostCommonMinusLeastCommon(List<String> template) {
  final groups = template.groupFoldBy<String, int>(
      (element) => element, (int? previous, _) => (previous ?? 0) + 1);
  final sortedCounts = groups.values.toList()..sort();
  return sortedCounts.last - sortedCounts.first;
}

List<String> runIteration(
  List<String> currentTemplate,
  Map<String, String> rules,
) {
  final sw = Stopwatch()..start();

  final startPairing = sw.elapsed;
  final chunks = <Pair>[];
  for (var i = 0; i < currentTemplate.length; i++) {
    if (i + 1 == currentTemplate.length) continue;
    chunks.add(Pair(currentTemplate[i], currentTemplate[i + 1]));
  }
  print('Spent ${sw.elapsed - startPairing} in pairing');

  final newTemplateBuffer = <String>[];
  final startInserting = sw.elapsed;
  final chunksWithInsertions =
      chunks.map((c) => [c.a, rules[c.combined]!, c.b]).toList();
  print('Spent ${sw.elapsed - startInserting} in inserting');

  final startCombining = sw.elapsed;
  for (var i = 0; i < chunksWithInsertions.length; i++) {
    if (i == 0) {
      newTemplateBuffer.addAll(chunksWithInsertions[i]);
    } else {
      newTemplateBuffer.addAll(chunksWithInsertions[i].skip(1));
    }
  }
  print('Spent ${sw.elapsed - startCombining} in combining');

  return newTemplateBuffer;
}

class Pair {
  final String a;
  final String b;

  Pair(this.a, this.b);

  String get combined => "$a$b";

  @override
  String toString() => "$a$b";
}
