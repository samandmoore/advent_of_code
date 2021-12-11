import 'dart:io';

const openParen = '(';
const closeParen = ')';
const openSquare = '[';
const closeSquare = ']';
const openCurly = '{';
const closeCurly = '}';
const openAngle = '<';
const closeAngle = '>';
const errorScoring = {
  closeParen: 3,
  closeSquare: 57,
  closeCurly: 1197,
  closeAngle: 25137,
};
const incompleteScoring = {
  ')': 1,
  ']': 2,
  '}': 3,
  '>': 4,
};

const pairs = {
  closeParen: openParen,
  closeSquare: openSquare,
  closeCurly: openCurly,
  closeAngle: openAngle,
};

const reversePairs = {
  openParen: closeParen,
  openSquare: closeSquare,
  openCurly: closeCurly,
  openAngle: closeAngle,
};

void main() {
  final lines = File('input.txt').readAsLinesSync();
  final results = <LineResult>[];

  for (final line in lines) {
    final result = processLine(line);
    results.add(result);
  }

  final corruptedLines = results.where((r) => r.isCorrupted).toList();
  final corruptionScore = corruptedLines
      .map((r) => errorScoring[r.errorCharacter]!)
      .reduce((sum, value) => sum + value);
  print('The corruption score is $corruptionScore');

  final incompleteLines = results.where((r) => !r.isCorrupted).toList();
  final incompletionScores = incompleteLines.map((r) => r.completionCharacters
      .fold(
          0,
          (int previousValue, element) =>
              (previousValue * 5) + incompleteScoring[element]!));
  print('Incompletion scores');
  print(incompleteLines.map((r) => r.completionCharacters).join('\n'));
  print(incompletionScores.join('\n'));
  final score = (incompletionScores.toList()
    ..sort())[(incompletionScores.length / 2).floor()];
  print('The incompletion score is $score');
}

LineResult processLine(String line) {
  final stack = <String>[];

  for (final character in line.split('')) {
    switch (character) {
      case openParen:
      case openCurly:
      case openSquare:
      case openAngle:
        stack.add(character);
        break;
      case closeParen:
      case closeSquare:
      case closeCurly:
      case closeAngle:
        if (stack[stack.length - 1] == pairs[character]!) {
          stack.removeAt(stack.length - 1);
        } else {
          return LineResult(
            line: line,
            errorCharacter: character,
            lineErrorType: LineErrorType.corrupted,
          );
        }
        break;
    }
  }

  if (stack.isNotEmpty) {
    return LineResult(
      line: line,
      completionCharacters:
          stack.reversed.map((c) => reversePairs[c]!).toList(),
      lineErrorType: LineErrorType.incomplete,
    );
  }

  return LineResult(
    line: line,
    lineErrorType: LineErrorType.none,
  );
}

class LineResult {
  final String line;
  final String errorCharacter;
  final List<String> completionCharacters;
  final LineErrorType lineErrorType;

  LineResult({
    required this.line,
    this.errorCharacter = '',
    this.completionCharacters = const [],
    required this.lineErrorType,
  });

  bool get isCorrupted => lineErrorType == LineErrorType.corrupted;
}

enum LineErrorType { none, incomplete, corrupted }
