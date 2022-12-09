import 'dart:io';

class Queue<T> {
  final List<T> _items = [];

  Queue(List<T> items) {
    _items.addAll(items);
  }

  void push(T item) {
    _items.add(item);
  }

  T pop() {
    return _items.removeAt(0);
  }

  T peek() {
    return _items.first;
  }

  bool get isEmpty => _items.isEmpty;
}

void main() {
  final dirs = <String, int>{};
  final terminalLines = File('input-part-1.txt').readAsLinesSync();
  final queue = Queue<String>(terminalLines);
  final currentPath = <String>[];

  while (!queue.isEmpty) {
    final line = queue.pop();
    print(line);
    final parts = line.split(' ');
    if (parts.first == '\$') {
      final command = parts[1];
      switch (command) {
        case 'cd':
          if (parts[2] == '..') {
            currentPath.removeLast();
          } else {
            currentPath.add(parts[2]);
            dirs.putIfAbsent(buildDirName(currentPath), () => 0);
          }
          break;
        case 'ls':
          //
          break;
        default:
          throw Exception('Unknown command: $command');
      }
    } else if (parts.first == 'dir') {
      dirs.putIfAbsent(
        buildDirName(List.of(currentPath)..add(parts[1])),
        () => 0,
      );
    } else if (RegExp(r'\d+').hasMatch(parts.first)) {
      final size = int.parse(parts.first);
      final paths = List.of(currentPath);
      while (paths.isNotEmpty) {
        dirs[buildDirName(paths)] = dirs[buildDirName(paths)]! + size;
        paths.removeLast();
      }
    } else {
      throw Exception('Unknown line: $line');
    }
    print(currentPath);
  }

  print(dirs);

  final totalDiskSpace = 70000000;
  final requiredDiskSpace = 30000000;
  final totalUsedSpace = dirs['/']!;
  final totalUnusedSpace = totalDiskSpace - totalUsedSpace;
  print(totalUnusedSpace);

  final entriesSortedBySizeSmallestFirst = dirs.entries.toList()
    ..sort((a, b) => a.value.compareTo(b.value));

  for (final dir in entriesSortedBySizeSmallestFirst) {
    final usedSpace = dir.value;
    if (totalUnusedSpace + usedSpace >= requiredDiskSpace) {
      print(dir.key);
      print(dir.value);
      break;
    }
  }
}

String buildDirName(List<String> parts) {
  return (parts.take(1).toList()..add(parts.skip(1).join('/'))).join('');
}
