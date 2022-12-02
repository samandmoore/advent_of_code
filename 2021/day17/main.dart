void main() {
  // target area: x=20..30, y=-10..-5
  // final targets = TargetRange(
  //   minX: 20,
  //   maxX: 30,
  //   minY: -10,
  //   maxY: -5,
  // );
  // target area: x=155..215, y=-132..-72
  final targets = TargetRange(
    minX: 155,
    maxX: 215,
    minY: -132,
    maxY: -72,
  );

  secondAttempt(targets);
}

void secondAttempt(TargetRange targets) {
  var maxY = 0;
  final workingPairs = <String>[];
  for (var x = 0; x < targets.maxX + 1; x++) {
    for (var y = targets.minY; y < targets.minY.abs(); y++) {
      final result = doesVelocityWork(targets, x, y);
      if (result.success) {
        workingPairs.add('$x, $y');
      }
      if (result.success && result.maxY > maxY) {
        maxY = result.maxY;
      }
    }
  }
  print(maxY);
  print(workingPairs.join('\n'));
  print(workingPairs.length);
}

void firstAttempt(TargetRange targets) {
  var xVelocity = 0, yVelocity = 0;
  var result = doesVelocityWork(targets, xVelocity, yVelocity);
  while (!result.success) {
    if (result.endX < targets.minX) {
      xVelocity++;
    }
    yVelocity++;
    result = doesVelocityWork(targets, xVelocity, yVelocity);
  }

  TestResult? previousResult = null;
  result = doesVelocityWork(targets, xVelocity, yVelocity);
  var maxY = result.maxY;
  while (result.success && result.maxY >= maxY) {
    maxY = result.maxY;
    yVelocity++;
    previousResult = result;
    result = doesVelocityWork(targets, xVelocity, yVelocity);
  }

  print(previousResult);
}

bool isCloserToTargetY(
  TargetRange targets,
  TestResult previous,
  TestResult current,
) {
  final previousYDiff = previous.endY - targets.minY;
  final yDiff = current.endY - targets.minY;
  print('previousDiff: $previousYDiff, diff: $yDiff');
  return yDiff <= previousYDiff;
}

TestResult doesVelocityWork(
  TargetRange targets,
  int startXVelocity,
  int startYVelocity,
) {
  var x = 0, y = 0;
  var xVelocity = startXVelocity;
  var yVelocity = startYVelocity;

  var success = false, failure = false, steps = 0, maxY = y;
  while (!success && !failure) {
    steps++;
    x += xVelocity;
    y += yVelocity;
    if (xVelocity > 0) {
      xVelocity--;
    } else if (xVelocity < 0) {
      xVelocity++;
    }
    yVelocity--;
    if (y > maxY) {
      maxY = y;
    }
    success = isInTargetRange(targets, x, y);
    failure = missedTargetRange(targets, x, y);
  }

  return TestResult(
    success: success,
    numberOfSteps: steps,
    startXVelocity: startXVelocity,
    startYVelocity: startYVelocity,
    maxY: maxY,
    endX: x,
    endY: y,
  );
}

bool isInTargetRange(TargetRange targets, int x, int y) {
  return x >= targets.minX &&
      x <= targets.maxX &&
      y >= targets.minY &&
      y <= targets.maxY;
}

bool missedTargetRange(TargetRange targets, int x, int y) {
  return x > targets.maxX || y < targets.minY;
}

class TestResult {
  final bool success;
  final int numberOfSteps;
  final int startXVelocity;
  final int startYVelocity;
  final int maxY;
  final int endX;
  final int endY;

  TestResult({
    required this.success,
    required this.numberOfSteps,
    required this.startXVelocity,
    required this.startYVelocity,
    required this.maxY,
    required this.endX,
    required this.endY,
  });

  @override
  String toString() =>
      '{success: $success, numberOfSteps: $numberOfSteps, maxY: $maxY, startXVelocity: $startXVelocity, startYVelocity: $startYVelocity, endX: $endX, endY: $endY}';
}

class TargetRange {
  final int minX;
  final int maxX;
  final int minY;
  final int maxY;

  TargetRange({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  });
}
