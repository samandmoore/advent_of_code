import 'dart:io';
import 'dart:math';

typedef Grid = List<List<String>>;

void main() {
  final lines = File('input.txt').readAsLinesSync();
  final enhancementAlgo = lines.first;
  var inputImage = lines
      .skip(2)
      .map(
        (l) => l.split('').toList(),
      )
      .toList();

  printImage(inputImage);

  final iterations = 50;
  var iteration = 1;
  var missingPixel = '.';
  late Grid resultImage;

  while (iteration <= iterations) {
    final resultHeight = inputImage.length + 2;
    final resultWidth = inputImage[0].length + 2;
    resultImage = List.generate(
      resultHeight,
      (_) => List.generate(
        resultWidth,
        (_) => 'x',
      ),
    );

    for (var y = -1; y <= inputImage.length; y++) {
      for (var x = -1; x <= inputImage[0].length; x++) {
        final pixels = getAdjacentPixels(
          image: inputImage,
          x: x,
          y: y,
          missingPixel: missingPixel,
        );
        final pixelDecimal = pixelsToDecimal(pixels);
        final newPixel = enhancementAlgo[pixelDecimal];
        resultImage[y + 1][x + 1] = newPixel;
      }
    }
    printImage(resultImage);

    inputImage = resultImage;
    missingPixel =
        enhancementAlgo[pixelsToDecimal(List.filled(9, missingPixel))];
    iteration++;
  }

  final litPixels = resultImage
      .expand((r) => r)
      .where(
        (p) => p == '#',
      )
      .toList()
      .length;
  print(litPixels);
}

List<String> getAdjacentPixels({
  required Grid image,
  required int x,
  required int y,
  required String missingPixel,
}) {
  return [
    getPixelInImage(
        image: image, missingPixel: missingPixel, y: y - 1, x: x - 1),
    getPixelInImage(image: image, missingPixel: missingPixel, y: y - 1, x: x),
    getPixelInImage(
        image: image, missingPixel: missingPixel, y: y - 1, x: x + 1),
    getPixelInImage(image: image, missingPixel: missingPixel, y: y, x: x - 1),
    getPixelInImage(image: image, missingPixel: missingPixel, y: y, x: x),
    getPixelInImage(image: image, missingPixel: missingPixel, y: y, x: x + 1),
    getPixelInImage(
        image: image, missingPixel: missingPixel, y: y + 1, x: x - 1),
    getPixelInImage(image: image, missingPixel: missingPixel, y: y + 1, x: x),
    getPixelInImage(
        image: image, missingPixel: missingPixel, y: y + 1, x: x + 1),
  ];
}

String getPixelInImage({
  required Grid image,
  required String missingPixel,
  required int x,
  required int y,
}) {
  final width = image[0].length;
  final height = image.length;

  if (y >= 0 && y < height) {
    if (x >= 0 && x < width) {
      return image[y][x];
    }
  }

  return missingPixel;
}

void printImage(Grid inputImage) {
  print('-------------------------');
  for (final line in inputImage) {
    for (var pixel in line) {
      stdout.write(pixel);
    }
    stdout.writeln();
  }
}

int pixelsToDecimal(List<String> pixels) {
  final binary = pixelsToBinary(pixels);
  var sum = 0;
  for (var i = 0; i < binary.length; i++) {
    final digit = binary[binary.length - 1 - i];
    if (digit == '1') {
      sum += pow(2, i).toInt();
    }
  }
  return sum;
}

String pixelsToBinary(List<String> pixels) {
  return pixels.map((p) => p == '#' ? '1' : '0').join('');
}
