import 'dart:io';

void main() {
  final rawInput = File('input.txt').readAsStringSync();
  final startingFish = rawInput.split(',').map((i) => int.parse(i));

  // make a list for each of the days, populate it with the count of fish
  // from the starting fish at each day.
  final fish = List.filled(9, 0, growable: true);
  startingFish.forEach((f) => fish[f]++);

  final numberOfDaysToRun = 256;
  var currentDay = 0;

  while (currentDay < numberOfDaysToRun) {
    final spawners = fish.removeAt(0);
    fish[6] += spawners;
    fish.add(spawners);
    currentDay++;
  }

  print(
      'After $numberOfDaysToRun days, there are ${fish.reduce((value, element) => value + element)} fish');
}
