import 'dart:io';
import 'dart:math';

void main() {
  // partOne(values);
  partTwo();
}

void partTwo() {
  final lines = File('input.txt').readAsLinesSync();
  final values = lines.map((l) => l.trim()).toList();

  var largestMagnitude = 0;
  for (var i = 0; i < values.length - 1; i++) {
    for (var j = 1; j < values.length; j++) {
      final a = Parser(input: values[i]).run() as Pair;
      final a1 = Parser(input: values[i]).run() as Pair;
      final b = Parser(input: values[j]).run() as Pair;
      final b1 = Parser(input: values[j]).run() as Pair;

      print('$a + $b');
      final aPlusB = a.add(b).magnitude;
      print(aPlusB);

      print('$b1 + $a1');
      final bPlusA = b1.add(a1).magnitude;
      print(bPlusA);

      largestMagnitude = max(largestMagnitude, max(aPlusB, bPlusA));
    }
  }
  print(largestMagnitude);
}

void partOne() {
  final lines = File('sample-input.txt').readAsLinesSync();
  final values = lines.map((l) => Parser(input: l.trim()).run()).toList();
  Pair result = values.first as Pair;
  for (final value in values.skip(1)) {
    print('  $result');
    print('+ $value');
    result = result.add(value as Pair);
    print('= $result');
  }

  print(result.magnitude);
}

class Parser {
  final String input;
  int position = 0;

  Parser({required this.input});

  NumberOrPair run() {
    return parseEither();
  }

  NumberOrPair parseEither() {
    if (currentCharacter == '[') {
      return parsePair();
    }
    return parseNumber();
  }

  Pair parsePair() {
    incrementPosition();
    final left = parseEither();
    incrementPosition();
    final right = parseEither();
    incrementPosition();
    return Pair(left: left, right: right);
  }

  Number parseNumber() {
    var start = position;
    while (currentCharacter != ',' && currentCharacter != ']') {
      incrementPosition();
    }
    final numberChars = input.substring(start, position);
    final number = int.parse(numberChars);
    return Number(value: number);
  }

  String get currentCharacter => input[position];

  void incrementPosition() {
    position++;
  }
}

abstract class NumberOrPair {
  Pair? parent;

  NumberOrPair();

  int get depth => parent == null ? 1 : parent!.depth + 1;

  bool get isRoot => parent == null;

  bool get isLeft => parent?.left == this;

  bool get isRight => parent?.right == this;

  bool get isExplodable;

  bool get isSplitable;

  bool maybeExplode();

  bool maybeSplit();

  Number? findRightmostRegular();

  Number? findLeftmostRegular();

  int get magnitude;
}

class Number extends NumberOrPair {
  int value;

  Number({required this.value});

  @override
  String toString() => '$value';

  @override
  int get hashCode => Object.hash(value, value);

  @override
  bool get isExplodable => false;

  @override
  bool get isSplitable => value >= 10;

  @override
  bool maybeExplode() {
    return false;
  }

  @override
  bool maybeSplit() {
    if (!isSplitable) {
      return false;
    }

    final newPair = Pair(
      left: Number(value: (value / 2).floor()),
      right: Number(value: (value / 2).ceil()),
    );

    if (isLeft) {
      parent!.left = newPair;
    } else {
      parent!.right = newPair;
    }

    return true;
  }

  @override
  Number? findLeftmostRegular() => this;

  @override
  Number? findRightmostRegular() => this;

  int get magnitude => value;
}

class Pair extends NumberOrPair {
  late NumberOrPair _left;
  late NumberOrPair _right;

  Pair({required NumberOrPair left, required NumberOrPair right}) {
    this.left = left;
    this.right = right;
  }

  NumberOrPair get left => _left;

  NumberOrPair get right => _right;

  set left(NumberOrPair value) {
    _left = value;
    value.parent = this;
  }

  set right(NumberOrPair value) {
    _right = value;
    value.parent = this;
  }

  @override
  String toString() => '[$_left,$_right]';

  @override
  int get hashCode => Object.hash(_left, _right);

  @override
  bool get isExplodable {
    if (_isSelfExplodable) {
      return true;
    }

    return left.isExplodable || right.isExplodable;
  }

  bool get _isSelfExplodable {
    if (depth >= 5) {
      return left is Number && right is Number;
    }
    return false;
  }

  @override
  bool get isSplitable => left.isSplitable || right.isSplitable;

  @override
  bool maybeExplode() {
    if (_isSelfExplodable) {
      final numberToLeft = findFirstRegularToLeft();
      final numberToRight = findFirstRegularToRight();

      numberToLeft?.value += (left as Number).value;
      numberToRight?.value += (right as Number).value;

      if (isLeft) {
        parent!.left = Number(value: 0);
      } else {
        parent!.right = Number(value: 0);
      }
      return true;
    }

    return left.maybeExplode() || right.maybeExplode();
  }

  @override
  bool maybeSplit() {
    return left.maybeSplit() || right.maybeSplit();
  }

  Number? findFirstRegularToLeft() {
    if (isRight) {
      return parent!.left.findRightmostRegular();
    } else {
      return parent?.findFirstRegularToLeft();
    }
  }

  Number? findFirstRegularToRight() {
    if (isLeft) {
      return parent!.right.findLeftmostRegular();
    } else {
      return parent?.findFirstRegularToRight();
    }
  }

  @override
  Number? findLeftmostRegular() {
    return left.findLeftmostRegular();
  }

  @override
  Number? findRightmostRegular() {
    return right.findRightmostRegular();
  }

  Pair add(Pair other) {
    return Pair(left: this, right: other)..reduce();
  }

  void reduce() {
    while (isExplodable || isSplitable) {
      maybeExplode() || maybeSplit();
      // print(this);
    }
  }

  int get magnitude => (3 * left.magnitude) + (2 * right.magnitude);
}
