import 'dart:io';

void main() {
  final rawInput = File('input.txt').readAsStringSync();
  final startingFish = rawInput.split(',').map((i) => int.parse(i));

  final daysToFish = <int, int>{};

  // map it empty
  List.generate(9, (index) => index).forEach((index) => daysToFish[index] = 0);

  // populate it with the starting fish
  startingFish.forEach((f) => daysToFish[f] = daysToFish[f]! + 1);

  final numberOfDaysToRun = 256;
  var currentDay = 0;

  while (currentDay < numberOfDaysToRun) {
    final zeroes = daysToFish[0]!;
    final ones = daysToFish[1]!;
    final twos = daysToFish[2]!;
    final threes = daysToFish[3]!;
    final fours = daysToFish[4]!;
    final fives = daysToFish[5]!;
    final sixes = daysToFish[6]!;
    final sevens = daysToFish[7]!;
    final eights = daysToFish[8]!;
    // add number of 0s to 8
    daysToFish[8] = zeroes;
    // swap 8 to 7
    daysToFish[7] = eights;
    // swap 7 to 6
    daysToFish[6] = sevens;
    // swap 6 to 5
    daysToFish[5] = sixes;
    // swap 5 to 4
    daysToFish[4] = fives;
    // swap 4 to 3
    daysToFish[3] = fours;
    // swap 3 to 2
    daysToFish[2] = threes;
    // swap 2 to 1
    daysToFish[1] = twos;
    // swap 1 to 0
    daysToFish[0] = ones;
    // swap 0 to 6
    daysToFish[6] = daysToFish[6]! + zeroes;

    currentDay++;
  }

  print(
      'After $numberOfDaysToRun days, there are ${daysToFish.values.reduce((value, element) => value + element)} fish');
}
