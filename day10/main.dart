import 'dart:io';

typedef Pos = ({int x, int y});

typedef Map = List<List<int>>;

List<Pos> findTrailheads(Map map) {
  final List<Pos> result = [];
  for (int y = 0; y < map.length; y++) {
    for (int x = 0; x < map.first.length; x++) {
      if (map[y][x] == 0) {
        result.add((x: x, y: y));
      }
    }
  }
  return result;
}

List<Pos> findSurrounding(Pos pos) => [
      (x: pos.x, y: pos.y - 1),
      (x: pos.x + 1, y: pos.y),
      (x: pos.x, y: pos.y + 1),
      (x: pos.x - 1, y: pos.y),
    ];

bool isValid(Pos pos, Map map, int height) =>
    pos.x >= 0 && pos.y >= 0 && pos.x < map.first.length && pos.y < map.length && map[pos.y][pos.x] == height;

Set<Pos> trailheadScorePart1(Map map, Pos pos, [List<Pos>? visitedPositions]) {
  final visited = visitedPositions ?? [];
  final height = map[pos.y][pos.x];
  if (height == 9) return {pos};
  final next = findSurrounding(pos).where((pos) => isValid(pos, map, height + 1) && !visited.contains(pos));
  if (next.isEmpty) return {};
  return next.map((n) => trailheadScorePart1(map, n, [...visited, pos])).reduce((a, b) => a.union(b));
}

Set<String> trailheadScorePart2(Map map, Pos pos, [List<Pos>? visitedPositions]) {
  final visited = visitedPositions ?? [];
  final visitedAndCurrent = [...visited, pos];
  final height = map[pos.y][pos.x];
  if (height == 9) return {visitedAndCurrent.map((p) => p.toString()).join("-")};
  final next = findSurrounding(pos).where((pos) => isValid(pos, map, height + 1) && !visited.contains(pos));
  if (next.isEmpty) return {};
  return next.map((n) => trailheadScorePart2(map, n, visitedAndCurrent)).reduce((a, b) => a.union(b));
}

void main() async {
  final map = (await File("day10/input").readAsLines()).map((line) => line.split("").map((i) => int.parse(i)).toList()).toList();

  final heads = findTrailheads(map);

  final part1 = heads.map((head) => trailheadScorePart1(map, head)).map((s) => s.length).reduce((a, b) => a + b);

  print("part1: $part1");

  final part2 = heads.map((head) => trailheadScorePart2(map, head)).map((s) => s.length).reduce((a, b) => a + b);

  print("part2: $part2");
}
