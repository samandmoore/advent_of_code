import 'dart:collection';
import 'dart:io';

void main() {
  final rawLines = File('input.txt').readAsLinesSync();
  final numbers = parseNumbers(rawLines.removeAt(0));
  final boards = parseBoardsFromInput(rawLines..removeAt(0));

  final winner = determineWinningBoard(numbers, boards);

  if (winner != null) {
    print('The winning board is:');
    print('$winner');
    print('Winning score: ${winner.calculateWinningScore()}');
  } else {
    print('Doh! No winner found.');
  }
}

Board? determineWinningBoard(Iterable<int> numbers, List<Board> boards) {
  for (final number in numbers) {
    for (final board in boards) {
      board.addNumber(number);
      if (board.checkForWinner()) {
        return board;
      }
    }
  }
  return null;
}

Iterable<int> parseNumbers(String numbers) {
  return numbers.split(',').map((n) => int.parse(n));
}

List<Board> parseBoardsFromInput(List<String> rawLines) {
  final boards = <Board>[];
  var rows = <List<int>>[];

  for (final line in rawLines) {
    if (line.isEmpty) {
      boards.add(Board.fromInts(rawRows: rows));
      rows = [];
      continue;
    }
    final row = line
        .split(' ')
        .where((s) => s.isNotEmpty)
        .map((n) => int.parse(n))
        .toList();
    rows.add(row);
  }

  return boards;
}

class Number {
  final int value;
  bool isHit;

  Number({required this.value, this.isHit = false});

  void markHit() {
    isHit = true;
  }

  String toString() {
    return '$value ($isHit)';
  }
}

class Board {
  final Set<int> hits = LinkedHashSet();
  final List<List<Number>> rows;

  Board({required this.rows});

  factory Board.fromInts({required List<List<int>> rawRows}) {
    return Board(
      rows: rawRows
          .map(
            (r) => r.map((n) => Number(value: n)).toList(),
          )
          .toList(),
    );
  }

  void addNumber(int number) {
    for (final row in rows) {
      for (final num in row) {
        if (num.value == number) {
          num.markHit();
          hits.add(number);
        }
      }
    }
  }

  bool checkForWinner() {
    final anyWinningRow = rows.any(
      (row) => row.every((number) => number.isHit),
    );
    final anyWinningColumn = columnsForRows.any(
      (column) => column.every((number) => number.isHit),
    );
    return anyWinningRow || anyWinningColumn;
  }

  int calculateWinningScore() {
    final unmarkedNumbersSum = rows
        .expand(
          (row) => row
              .where(
                (number) => !number.isHit,
              )
              .map(
                (number) => number.value,
              ),
        )
        .reduce(
          (value, element) => value + element,
        );

    return unmarkedNumbersSum * hits.last;
  }

  List<List<Number>> get columnsForRows {
    final result = <List<Number>>[];
    final numberOfColumns = rows.first.length;

    for (var columnIndex = 0; columnIndex < numberOfColumns; columnIndex++) {
      result.add(rows.map((row) => row[columnIndex]).toList());
    }

    return result;
  }

  String toString() {
    return rows.map((r) => r.join('\t')).join('\n');
  }
}
