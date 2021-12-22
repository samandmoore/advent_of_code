void main() {
  final input = '''
    Player 1 starting position: 1
    Player 2 starting position: 5
  ''';
  final startingPositions = input
      .trim()
      .split('\n')
      .map(
        (l) => l.split(':').last.trim(),
      )
      .map(
        (v) => int.parse(v),
      );
  const winningScore = 1000;
  final scores = {
    0: 0,
    1: 0,
  };
  final positions = {
    0: startingPositions.first,
    1: startingPositions.last,
  };
  var turnIndex = 0;
  final die = DeterministicDie();

  final roll_sums_frequency = {
    3: 1,
    4: 3,
    5: 6,
    6: 7,
    7: 6,
    8: 3,
    9: 1,
  };

  while (scores.values.every((score) => score < winningScore)) {
    // even number is player one, odd number is player two
    final playerIndex = turnIndex % 2;
    final rolls = [die.roll(), die.roll(), die.roll()];
    final spacesToMove = rolls.fold(0, (int sum, roll) => sum + roll);
    final currentPosition = positions[playerIndex]!;
    // 5 + 6 = 11 % 10 = 1
    var newPosition = (currentPosition + spacesToMove) % 10;
    if (newPosition == 0) {
      newPosition = 10;
    }
    positions[playerIndex] = newPosition;
    scores[playerIndex] = scores[playerIndex]! + newPosition;
    print(
        'Player ${playerIndex + 1} rolls ${rolls} and moves to space ${newPosition} for a total score of ${scores[playerIndex]}');

    turnIndex++;
  }

  final loser = scores[0]! < winningScore ? 0 : 1;
  print('Player #${loser + 1} loses with a score of ${scores[loser]}');
  final result = scores[loser]! * die.rollCount;
  print('Die was rolled ${die.rollCount} for a result of $result');
}

class DeterministicDie {
  var _nextValue = 1;
  var rollCount = 0;

  int roll() {
    final value = _nextValue;
    rollCount++;

    _nextValue++;
    if (_nextValue > 100) {
      _nextValue = 1;
    }

    return value;
  }
}

/*
3 1 1 1
4 1 1 2
5 1 1 3
4 1 2 1
5 1 2 2
6 1 2 3
5 1 3 1
6 1 3 2
7 1 3 3
4 2 1 1
5 2 1 2
6 2 1 3
5 2 2 1
6 2 2 2
7 2 2 3
6 2 3 1
7 2 3 2
8 2 3 3
5 3 1 1
6 3 1 2
7 3 1 3
6 3 2 1
7 3 2 2
8 3 2 3
7 3 3 1
8 3 3 2
9 3 3 3
*/

