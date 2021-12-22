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
