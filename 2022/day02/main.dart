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

Result resultFromString(String value) {
  switch (value.toLowerCase()) {
    case 'x':
      return Result.lose;
    case 'y':
      return Result.draw;
    case 'z':
      return Result.win;
    default:
      throw Exception('Invalid result: $value');
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
  final Play opponent;
  final Result result;
  Round({required this.opponent, required this.result});

  Play get yourPlay {
    switch (result) {
      case Result.win:
        return opponent == Play.rock
            ? Play.paper
            : opponent == Play.paper
                ? Play.scissors
                : Play.rock;
      case Result.lose:
        return opponent == Play.rock
            ? Play.scissors
            : opponent == Play.paper
                ? Play.rock
                : Play.paper;
      case Result.draw:
        return opponent;
    }
  }

  int get score {
    return scoreForPlay(yourPlay) + scoreForResult(result);
  }
}

void main() {
  final rawLines = File('input-part-1.txt').readAsLinesSync();
  final rounds = rawLines
      .map(
        (line) => line.split(' ').toList(),
      )
      .map(
        (inputs) => Round(
          opponent: playFromString(inputs.first),
          result: resultFromString(inputs.last),
        ),
      )
      .toList();
  final yourScore = rounds.map((round) => round.score).reduce((a, b) => a + b);
  print(yourScore);
}
