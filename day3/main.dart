import 'dart:io';

void main() {
  final rawReportLines = File('input.txt').readAsLinesSync();
  final gammaRate = computeGammaRate(rawReportLines);
  final epsilonRate = computeEpsilonRate(gammaRate);
  final gammaRateDecimal = int.parse(gammaRate, radix: 2);
  final epsilonRateDecimal = int.parse(epsilonRate, radix: 2);
  print(
    'Gamma Rate ($gammaRate) * Epsilon Rate ($epsilonRate) ' +
        '= ${gammaRateDecimal * epsilonRateDecimal}',
  );
}

String computeGammaRate(List<String> reportLines) {
  final length = reportLines[0].length;
  var result = '';

  for (var digitIndex = 0; digitIndex < length; digitIndex++) {
    var ones = 0;
    var zeroes = 0;

    for (var reportLineIndex = 0;
        reportLineIndex < reportLines.length;
        reportLineIndex++) {
      final digit = reportLines[reportLineIndex][digitIndex];
      if (digit == '1') {
        ones++;
      } else {
        zeroes++;
      }
    }

    if (ones > zeroes) {
      result += '1';
    } else {
      result += '0';
    }
  }

  return result;
}

String computeEpsilonRate(String gammaRate) {
  var result = '';

  for (var gammaRateIndex = 0;
      gammaRateIndex < gammaRate.length;
      gammaRateIndex++) {
    if (gammaRate[gammaRateIndex] == '1') {
      result += '0';
    } else {
      result += '1';
    }
  }

  return result;
}
