void main() {
  slightlyLargerExample();
}

void slightlyLargerExample() {
  final rawNumbers = '''
    [[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]
    [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
  '''
      .trim()
      .split('\n')
      .map((l) => l.trim())
      .toList();

  final firstRawNumber = rawNumbers.first;
  final firstNumber = parseNumber(firstRawNumber);
  var number = firstNumber;

//  [[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]
//+ [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
//= [[[[7,7],[7,7]],[[7,8],[7,8]]],[[[8,9],[7,7]],[[9,5],[9,0]]]]
//
//  should be...
//  [[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]

  for (final rawNumber in rawNumbers.skip(1)) {
    final newNumber = parseNumber(rawNumber);
    print('  $number');
    print('+ $newNumber');
    number = add(number, newNumber);
    reduce(number);
    print('= $number');
    print('');
  }
}

void partOne() {
  final rawNumbers = '''
    [1,1]
    [2,2]
    [3,3]
    [4,4]
    [5,5]
  '''
      .trim()
      .split('\n')
      .map((l) => l.trim())
      .toList();

  final firstRawNumber = rawNumbers.first;
  final firstNumber = parseNumber(firstRawNumber);
  var number = firstNumber;

  for (final rawNumber in rawNumbers.skip(1)) {
    final newNumber = parseNumber(rawNumber);
    number = add(number, newNumber);
    print(number);
    reduce(number);
    print(number);
  }
}

void reduceWithExplodeAndSplitExample() {
  var number = parseNumber('[[[[4,3],4],4],[7,[[8,4],9]]]');
  number = add(number, parseNumber('[1,1]'));
  print(number);
  reduce(number);
  print(number);
}

void splitExamples() {
  var number = parseNumber('[[[[0,7],4],[15,[0,13]]],[1,1]]');
  var toSplit = findNextToSplit(number);
  print(number);
  print(toSplit);

  number = parseNumber('[[[[0,7],4],[[7,8],[0,13]]],[1,1]]');
  toSplit = findNextToSplit(number);
  print(number);
  print(toSplit);
}

void explodeExamples() {
  var number = parseNumber('[[[[[9,8],1],2],3],4]');
  var toExplode = findNextToExplode(number);
  var regularToLeft = findRegularToLeft(toExplode!);
  var regularToRight = findRegularToRight(toExplode);
  print(number);
  print(toExplode);
  print(regularToLeft == null);
  print(regularToRight!.value == 1);
  reduce(number);
  print(number);
  print('--------------------------');

  number = parseNumber('[7,[6,[5,[4,[3,2]]]]]');
  toExplode = findNextToExplode(number);
  regularToLeft = findRegularToLeft(toExplode!);
  regularToRight = findRegularToRight(toExplode);
  print(number);
  print(toExplode);
  print(regularToLeft?.value == 4);
  print(regularToRight == null);
  reduce(number);
  print(number);
  print('--------------------------');

  number = parseNumber('[[6,[5,[4,[3,2]]]],1]');
  toExplode = findNextToExplode(number);
  regularToLeft = findRegularToLeft(toExplode!);
  regularToRight = findRegularToRight(toExplode);
  print(number);
  print(toExplode);
  print(regularToLeft!.value == 4);
  print(regularToRight!.value == 1);
  reduce(number);
  print(number);
  print('--------------------------');

  number = parseNumber('[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]');
  toExplode = findNextToExplode(number);
  regularToLeft = findRegularToLeft(toExplode!);
  regularToRight = findRegularToRight(toExplode);
  print(number);
  print(toExplode);
  print(regularToLeft!.value == 1);
  print(regularToRight!.value == 6);
  reduce(number);
  print(number);
  print('--------------------------');

  number = parseNumber('[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]');
  toExplode = findNextToExplode(number);
  regularToLeft = findRegularToLeft(toExplode!);
  regularToRight = findRegularToRight(toExplode);
  print(number);
  print(toExplode);
  print(regularToLeft!.value == 4);
  print(regularToRight == null);
  reduce(number);
  print(number);
  print('--------------------------');
}

void reduce(SnailfishPair number) {
  var toExplode = findNextToExplode(number);
  var toSplit = findNextToSplit(number);
  print(number);
  while (toExplode != null || toSplit != null) {
    if (toExplode != null) {
      var regularToLeft = findRegularToLeft(toExplode);
      var regularToRight = findRegularToRight(toExplode);

      final parent = (toExplode.parent as SnailfishPair);
      final newNumber = RegularNumber(0)..parent = parent;
      if (parent.left == toExplode) {
        if (regularToRight != null &&
            regularToRight.parent == toExplode.parent) {
          final right = (toExplode.right as RegularNumber);
          regularToRight.value = right.value + regularToRight.value;
        }
        parent.left = newNumber;
      }
      if (parent.right == toExplode) {
        if (regularToLeft != null && regularToLeft.parent == toExplode.parent) {
          final left = (toExplode.left as RegularNumber);
          regularToLeft.value = left.value + regularToLeft.value;
        }
        parent.right = newNumber;
      }

      if (regularToLeft != null && regularToLeft.parent != toExplode.parent) {
        regularToLeft.value =
            regularToLeft.value + (toExplode.left as RegularNumber).value;
      }
      if (regularToRight != null && regularToRight.parent != toExplode.parent) {
        regularToRight.value =
            regularToRight.value + (toExplode.right as RegularNumber).value;
      }
    } else if (toSplit != null) {
      final parent = toSplit.parent as SnailfishPair;
      final leftValue = (toSplit.value / 2).floor();
      final rightValue = (toSplit.value / 2).ceil();
      final pair = SnailfishPair(
        left: RegularNumber(leftValue),
        right: RegularNumber(rightValue),
      )..parent = parent;
      if (parent.left == toSplit) {
        parent.left = pair;
      }
      if (parent.right == toSplit) {
        parent.right = pair;
      }
    }
    toExplode = findNextToExplode(number);
    toSplit = findNextToSplit(number);
    print(number);
  }
}

RegularNumber? findRegularToLeft(
  SnailfishPair number, [
  SnailfishPair? previous,
]) {
  if (number.parent == null) {
    if (number.left != previous) {
      return findRightmostRegular(number.left);
    }
    return null;
  }

  final parent = number.parent! as SnailfishPair;

  if (parent.left != number) {
    if (parent.left is RegularNumber) {
      return parent.left as RegularNumber;
    }
    if (parent.left is SnailfishPair) {
      return findRightmostRegular(parent.left);
    }
  }

  return findRegularToLeft(parent, number);
}

RegularNumber? findRegularToRight(
  SnailfishPair number, [
  SnailfishPair? previous,
]) {
  if (number.parent == null) {
    if (number.right != previous) {
      return findLeftmostRegular(number.right);
    }
    return null;
  }

  final parent = number.parent! as SnailfishPair;

  if (parent.right != number) {
    if (parent.right is RegularNumber) {
      return parent.right as RegularNumber;
    }
    if (parent.right is SnailfishPair) {
      return findLeftmostRegular(parent.right);
    }
  }

  return findRegularToRight(parent, number);
}

RegularNumber? findLeftmostRegular(SnailfishNumber root) {
  if (root is RegularNumber) {
    return root;
  }

  if (root is SnailfishPair) {
    final leftNumber = findLeftmostRegular(root.left);
    if (leftNumber != null) {
      return leftNumber;
    }

    return findLeftmostRegular(root.right);
  }
}

RegularNumber? findRightmostRegular(SnailfishNumber root) {
  if (root is RegularNumber) {
    return root;
  }

  if (root is SnailfishPair) {
    final rightNumber = findRightmostRegular(root.right);
    if (rightNumber != null) {
      return rightNumber;
    }

    return findLeftmostRegular(root.left);
  }
}

SnailfishPair? findNextToExplode(SnailfishPair number, [int depth = 1]) {
  if (depth == 5) {
    return number;
  }

  if (number.left is SnailfishPair) {
    final left = findNextToExplode(number.left as SnailfishPair, depth + 1);
    if (left != null) {
      return left;
    }
  }

  if (number.right is SnailfishPair) {
    final right = findNextToExplode(number.right as SnailfishPair, depth + 1);
    if (right != null) {
      return right;
    }
  }

  return null;
}

RegularNumber? findNextToSplit(SnailfishNumber number) {
  if (number is RegularNumber && number.value >= 10) {
    return number;
  }

  if (number is SnailfishPair) {
    final left = findNextToSplit(number.left);
    if (left != null) {
      return left;
    }

    final right = findNextToSplit(number.right);
    if (right != null) {
      return right;
    }
  }

  return null;
}

SnailfishPair add(SnailfishPair a, SnailfishPair b) {
  return SnailfishPair(left: a, right: b);
}

SnailfishPair parseNumber(String rawNumber) {
  int findComma(String rawNumber) {
    var open = 0;
    for (var i = 0; i < rawNumber.length; i++) {
      final char = rawNumber[i];
      if (char == '[') {
        open++;
      } else if (char == ']') {
        open--;
      } else if (char == ',') {
        if (open == 1) {
          return i;
        }
      }
    }
    throw Exception('malformed input!');
  }

  final commaIndex = findComma(rawNumber);

  return SnailfishPair(
    left: parseNumberInner(
      rawNumber.substring(1, commaIndex),
    ),
    right: parseNumberInner(
      rawNumber.substring(commaIndex + 1, rawNumber.length - 1),
    ),
  );
}

SnailfishNumber parseNumberInner(String raw) {
  if (raw[0] != '[') {
    return RegularNumber(int.parse(raw));
  }
  return parseNumber(raw);
}

abstract class SnailfishNumber {
  SnailfishNumber? parent;

  SnailfishNumber({this.parent});
}

class SnailfishPair extends SnailfishNumber {
  SnailfishNumber left;
  SnailfishNumber right;

  SnailfishPair({required this.left, required this.right}) {
    left.parent = this;
    right.parent = this;
  }

  @override
  bool operator ==(Object? other) =>
      other is SnailfishPair &&
      identical(parent, other.parent) &&
      identical(left, other.left) &&
      identical(right, other.right);

  @override
  String toString() {
    return '[$left,$right]';
  }
}

class RegularNumber extends SnailfishNumber {
  int value;

  RegularNumber(this.value);

  @override
  bool operator ==(Object? other) =>
      other is RegularNumber &&
      identical(parent, other.parent) &&
      value == other.value;

  @override
  String toString() {
    return value.toString();
  }
}
