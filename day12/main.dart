import 'dart:io';

void main() {
  final lines = File('input.txt').readAsLinesSync();
  final graph = buildAdjacencyList(lines);
  print(graph);

  final paths = <List<String>>[];
  findPaths(graph: graph, paths: paths, start: 'start', visited: []);
  final goodPaths = paths.where((p) => p.last == 'end');
  print('There are ${goodPaths.length} good paths');
  goodPaths.forEach(print);
}

bool isSmall(String value) => value.toLowerCase() == value;

List<String> findPaths({
  required Map<String, List<String>> graph,
  required List<List<String>> paths,
  required String start,
  required List<String> visited,
}) {
  visited.add(start);
  if (start == 'end') return visited;

  final adjacents = graph[start] ?? [];
  for (var adjacent in adjacents) {
    final visitedSameSmallTwice = visited
        .where((v) => isSmall(v))
        .fold(
          <String, int>{},
          (Map<String, int> map, key) {
            map[key] = (map[key] ?? 0) + 1;
            return map;
          },
        )
        .values
        .any((v) => v > 1);

    if (isSmall(adjacent) &&
        visited.contains(adjacent) &&
        visitedSameSmallTwice) continue;

    paths.add(
      findPaths(
        graph: graph,
        paths: paths,
        start: adjacent,
        visited: List.of(visited),
      ),
    );
  }
  return visited;
}

Map<String, List<String>> buildAdjacencyList(List<String> lines) {
  final adjacencyList = <String, List<String>>{};
  lines.forEach((line) {
    final parts = line.split('-');
    final vertA = parts.first;
    final vertB = parts.last;
    final aEdges = adjacencyList.putIfAbsent(vertA, () => []);
    if (vertB != 'start') {
      aEdges.add(vertB);
    }
    final bEdges = adjacencyList.putIfAbsent(vertB, () => []);
    if (vertA != 'start') {
      bEdges.add(vertA);
    }
  });
  return adjacencyList;
}
