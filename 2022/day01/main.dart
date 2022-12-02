import 'dart:io';

import 'package:collection/collection.dart';

class Elf {
  final int number;
  final List<int> meals;

  Elf({
    required this.number,
    required this.meals,
  });

  int get totalCalories => meals.reduce((value, element) => value + element);

  String toString() => '{ number: $number, meals: $meals }';
}

void main() {
  final rawLines = File('input-part-1.txt').readAsLinesSync();

  final elves = <Elf>[];
  var currentElfFoods = <int>[];

  for (final line in rawLines) {
    if (line.isEmpty) {
      elves.add(Elf(number: elves.length + 1, meals: currentElfFoods));
      currentElfFoods = <int>[];
    } else {
      final calories = int.parse(line);
      currentElfFoods.add(calories);
    }
  }

  elves.sortBy<num>((element) => element.totalCalories);
  final mostCaloriesElf = elves.last;

  print(elves);
  print(mostCaloriesElf.number);
  print(mostCaloriesElf.totalCalories);
  final top3Elves = elves.skip(elves.length - 3).take(3);
  print(top3Elves);
  print(top3Elves
      .map((e) => e.totalCalories)
      .reduce((value, element) => value + element));
}
