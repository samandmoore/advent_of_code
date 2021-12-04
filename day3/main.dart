import 'dart:io';

void main() {
  final rawReportLines = File('input.txt').readAsLinesSync();
  final oxygenGeneratorRating = computeRatingByCriteria(
    rawReportLines,
    (ones, zeroes) => ones.length >= zeroes.length ? ones : zeroes,
  );
  final c02ScrubberRating = computeRatingByCriteria(
    rawReportLines,
    (ones, zeroes) => ones.length >= zeroes.length ? zeroes : ones,
  );
  final lifeSupportRating = oxygenGeneratorRating.toDecimalFromBinary() *
      c02ScrubberRating.toDecimalFromBinary();

  print('Life support rating = $lifeSupportRating');
}

extension on String {
  int toDecimalFromBinary() {
    return int.parse(this, radix: 2);
  }
}

String computeRatingByCriteria(List<String> rawReportLines, Criteria criteria) {
  var values = List.of(rawReportLines);
  var valueIndex = 0;

  while (values.length > 1) {
    print('Computing $criteria with $values');
    values = findValuesMatchingCriteria(values, valueIndex, criteria);
    valueIndex++;
  }

  return values.first;
}

typedef Criteria = List<String> Function(
    List<String> ones, List<String> zeroes);

List<String> findValuesMatchingCriteria(
  List<String> values,
  int position,
  Criteria criteria,
) {
  final mapping = <String, List<String>>{};
  values.forEach((v) {
    final digit = v[position];
    mapping.putIfAbsent(digit, () => [])..add(v);
  });
  final ones = mapping['1'] ?? [];
  final zeroes = mapping['0'] ?? [];

  return criteria.call(ones, zeroes);
}
