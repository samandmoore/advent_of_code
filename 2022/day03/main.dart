import 'dart:io';

import 'package:collection/collection.dart';

class Rucksack {
  final String compartmentOne;
  final String compartmentTwo;

  Rucksack({required this.compartmentOne, required this.compartmentTwo});

  String get itemInBothComparments {
    return compartmentOne
        .split('')
        .toSet()
        .intersection(compartmentTwo.split('').toSet())
        .first;
  }

  Set<String> get allItemsAsSet {
    return Set.of((compartmentOne + compartmentTwo).split(''));
  }
}

int itemToPriority(String item) {
  final lower = "abcdefghijklmnopqrstuvwxyz".indexOf(item);
  if (lower > -1) {
    return lower + 1;
  }
  final upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".indexOf(item);
  if (upper > -1) {
    return upper + 27;
  }

  throw Exception("Invalid item: $item");
}

void main() {
  final lines = File('input-part-1.txt').readAsLinesSync();
  final rucksacks = lines
      .map(
        (line) => Rucksack(
          compartmentOne: line.substring(0, line.length ~/ 2),
          compartmentTwo: line.substring(line.length ~/ 2, line.length),
        ),
      )
      .toList();
  final groups = rucksacks.slices(3);
  final commonItems = groups.map((g) => findCommonItemInAll(g));
  print(commonItems);
  print(commonItems.map((e) => itemToPriority(e)).reduce((a, b) => a + b));
}

String findCommonItemInAll(List<Rucksack> group) {
  final allItems =
      group.map((r) => r.allItemsAsSet).reduce((a, b) => a.intersection(b));
  return allItems.first;
}
