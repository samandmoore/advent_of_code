import 'dart:io';

class Range {
  int start;
  int end;
  Range(this.start, this.end);

  bool covers(Range other) {
    return start <= other.start && end >= other.end;
  }

  bool overlaps(Range other) {
    return toList().intersection(other.toList()).isNotEmpty;
  }

  Set<int> toList() {
    return List.generate(end - start + 1, (i) => start + i).toSet();
  }
}

class Pair {
  Range a;
  Range b;
  Pair(this.a, this.b);
}

void main() {
  final lines = File('input-part-1.txt').readAsLinesSync();
  final pairs = lines.map((line) {
    final ranges = line.split(',');
    final a = ranges[0].split('-');
    final b = ranges[1].split('-');

    return Pair(
      Range(int.parse(a[0]), int.parse(a[1])),
      Range(int.parse(b[0]), int.parse(b[1])),
    );
  });

  final result = pairs
      .where((pair) => pair.a.overlaps(pair.b) || pair.b.overlaps(pair.a))
      .length;

  print(result);
}
