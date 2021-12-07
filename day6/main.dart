import 'dart:io';

void main() {
  final rawInput = File('input.txt').readAsStringSync();
  final startingFish =
      rawInput.split(',').map((i) => Fish(timer: int.parse(i)));
  final allFish = List.of(startingFish);
  final numberOfDaysToRun = 80;
  var currentDay = 0;

  while (currentDay < numberOfDaysToRun) {
    final newFish = <Fish>[];

    for (final fish in allFish) {
      if (fish.timer == 0) {
        newFish.add(Fish(timer: 8));
        fish.timer = 6;
      } else {
        fish.timer--;
      }
    }

    allFish.addAll(newFish);
    currentDay++;
  }

  print('After $numberOfDaysToRun days, there are ${allFish.length} fish');
}

class Fish {
  int timer;

  Fish({required this.timer});
}
