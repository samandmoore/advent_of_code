import 'package:collection/collection.dart';

class GameState {
  final Map<int, int> scores;
  final Map<int, int> positions;
  final int turnIndex;

  GameState({
    required this.scores,
    required this.positions,
    required this.turnIndex,
  });

  @override
  int get hashCode => Object.hash(
        DeepCollectionEquality().hash(scores),
        DeepCollectionEquality().hash(positions),
        turnIndex,
      );

  @override
  bool operator ==(Object? other) =>
      other is GameState &&
      DeepCollectionEquality().equals(scores, other.scores) &&
      DeepCollectionEquality().equals(positions, other.positions) &&
      turnIndex == other.turnIndex;
}

void main() {
  final startingPositions = getStartingPositions();

  const winningScore = 21;

  final rollSumsFrequency = {
    3: 1,
    4: 3,
    5: 6,
    6: 7,
    7: 6,
    8: 3,
    9: 1,
  };

  final initialState = GameState(
    positions: {0: startingPositions.first, 1: startingPositions.last},
    scores: {0: 0, 1: 0},
    turnIndex: 0,
  );
  var states = <GameState, int>{
    initialState: 1,
  };
  final winsByPlayer = {
    0: 0,
    1: 0,
  };

  while (states.isNotEmpty) {
    final newStates = <GameState, int>{};

    states.entries.forEach((entry) {
      final state = entry.key;
      final count = entry.value;
      // even number is player one, odd number is player two
      final playerIndex = state.turnIndex % 2;

      rollSumsFrequency.entries.forEach((entry) {
        final sum = entry.key;
        final numberOfOutcomes = entry.value;
        final currentPosition = state.positions[playerIndex]!;
        // 5 + 6 = 11 % 10 = 1
        var newPosition = (currentPosition + sum) % 10;
        if (newPosition == 0) {
          newPosition = 10;
        }
        final newState = GameState(
          positions: Map.of(state.positions)
            ..addAll({playerIndex: newPosition}),
          scores: Map.of(state.scores)
            ..addAll({playerIndex: state.scores[playerIndex]! + newPosition}),
          turnIndex: state.turnIndex + 1,
        );

        // check for winners and losers
        if (newState.scores[playerIndex]! >= winningScore) {
          winsByPlayer[playerIndex] =
              winsByPlayer[playerIndex]! + (count * numberOfOutcomes);
        } else {
          newStates[newState] ??= 0;
          newStates[newState] =
              newStates[newState]! + (count * numberOfOutcomes);
        }
      });
    });

    print('total states: ${newStates.length}');
    states = newStates;
  }

  print(winsByPlayer);
}

Iterable<int> getStartingPositions() {
  final sampleInput = '''
    Player 1 starting position: 4
    Player 2 starting position: 8
  ''';
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
  return startingPositions;
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
