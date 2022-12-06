import 'dart:io';

import 'package:collection/collection.dart';

class Instruction {
  final int count;
  final int from;
  final int to;

  Instruction({required this.count, required this.from, required this.to});

  String toString() => 'Instruction(count: $count, from: $from, to: $to)';
}

class Stack<T> {
  final List<T> _items = [];

  void push(T item) {
    _items.add(item);
  }

  T pop() {
    return _items.removeLast();
  }

  T peek() {
    return _items.last;
  }

  String toString() => _items.toString();
}

void main() {
  final lines = File('input-part-1.txt').readAsLinesSync();
  final stackLines = lines.takeWhile((value) => value.isNotEmpty).toList();
  final instructionLines = lines.skip(stackLines.length + 1).toList();

  final stacks = <int, Stack<String>>{};

  final chunkedStackLines = stackLines.reversed.map((line) {
    final chars = line.split('');
    return chars.slices(4).map((chunk) => chunk[1].trim()).toList();
  }).toList();

  final headerLine = chunkedStackLines.removeAt(0);
  headerLine.forEach((header) => stacks[int.parse(header)] = Stack<String>());

  chunkedStackLines.forEach((chunk) {
    chunk.forEachIndexed((index, element) {
      if (element.isNotEmpty) {
        stacks[index + 1]!.push(element);
      }
    });
  });

  final instructions = instructionLines.map((i) {
    final parts = i.split(' ');
    return Instruction(
      count: int.parse(parts[1]),
      from: int.parse(parts[3]),
      to: int.parse(parts[5]),
    );
  });

  print(stacks);
  print(instructions);

  instructions.forEach((instruction) {
    final fromStack = stacks[instruction.from]!;
    final toStack = stacks[instruction.to]!;

    final tempStack = Stack<String>();
    for (var i = 0; i < instruction.count; i++) {
      tempStack.push(fromStack.pop());
    }

    for (var i = 0; i < instruction.count; i++) {
      toStack.push(tempStack.pop());
    }
  });

  print(stacks);
  final topOfEachStack = stacks.values.map((stack) => stack.peek()).toList();
  print(topOfEachStack.join());
}
