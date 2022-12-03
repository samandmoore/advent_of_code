import 'dart:io';

enum Play {
  rock,
  paper,
  scissors,
}

int scoreForPlay(Play play) {
  switch (play) {
    case Play.rock:
      return 1;
    case Play.paper:
      return 2;
    case Play.scissors:
      return 3;
  }
}

Play playFromString(String value) {
  switch (value.toLowerCase()) {
    case 'a':
    case 'x':
      return Play.rock;
    case 'b':
    case 'y':
      return Play.paper;
    case 'c':
    case 'z':
      return Play.scissors;
    default:
      throw Exception('Invalid play: $value');
  }
}

enum Result {
  win,
  lose,
  draw,
}

int scoreForResult(Result result) {
  switch (result) {
    case Result.win:
      return 6;
    case Result.lose:
      return 0;
    case Result.draw:
      return 3;
  }
}

class Round {
  final Play you;
  final Play opponent;
  Round({required this.you, required this.opponent});

  Result get result {
    if (you == opponent) {
      return Result.draw;
    } else if (you == Play.rock && opponent == Play.scissors) {
      return Result.win;
    } else if (you == Play.paper && opponent == Play.rock) {
      return Result.win;
    } else if (you == Play.scissors && opponent == Play.paper) {
      return Result.win;
    } else {
      return Result.lose;
    }
  }

  int get score {
    return scoreForPlay(you) + scoreForResult(result);
  }
}

void main() {
  final rawLines = File('input-part-1.txt').readAsLinesSync();
  final rounds = rawLines
      .map(
        (line) => line
            .split(' ')
            .map(
              (play) => playFromString(play),
            )
            .toList(),
      )
      .map(
        (plays) => Round(opponent: plays.first, you: plays.last),
      )
      .toList();
  final yourScore = rounds.map((round) => round.score).reduce((a, b) => a + b);
  print(yourScore);
}
