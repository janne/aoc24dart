import 'dart:io';

typedef Pos = (int, int);

typedef Map = List<List<bool>>;

enum Direction { up, right, down, left }

Pos findStartPos(List<List<String>> map) {
  for (int y = 0; y < map.length; y++) {
    for (int x = 0; x < map.first.length; x++) {
      if (map[y][x] == "^") return (x, y);
    }
  }

  throw Exception("No start position found");
}

bool isInsideMap(Pos pos, Map map) {
  return pos.$1 >= 0 &&
      pos.$1 < map.first.length &&
      pos.$2 >= 0 &&
      pos.$2 < map.length;
}

Pos advancePos(Pos pos, Direction direction) => switch (direction) {
      Direction.up => (pos.$1, pos.$2 - 1),
      Direction.right => (pos.$1 + 1, pos.$2),
      Direction.down => (pos.$1, pos.$2 + 1),
      Direction.left => (pos.$1 - 1, pos.$2),
    };

int? countSteps(Map map, Pos initialPos) {
  final visited = <(Pos, Direction)>{};
  var direction = Direction.up;
  Pos pos = initialPos;

  while (true) {
    if (visited.any((posDir) => pos == posDir.$1 && direction == posDir.$2)) {
      return null;
    }
    visited.add((pos, direction));
    final newPos = advancePos(pos, direction);
    if (isInsideMap(newPos, map)) {
      if (map[newPos.$2][newPos.$1]) {
        direction = switch (direction) {
          Direction.up => Direction.right,
          Direction.right => Direction.down,
          Direction.down => Direction.left,
          Direction.left => Direction.up,
        };
      } else {
        pos = newPos;
      }
    } else {
      break;
    }
  }
  return visited.length;
}

int? introduceLoops(Map map, Pos initialPos) {
  int loops = 0;
  for (int y = 0; y < map.length; y++) {
    for (int x = 0; x < map.first.length; x++) {
      final progress =
          (y * map.first.length + x) / (map.first.length * map.length) * 100;
      print("progress: ${progress.toStringAsFixed(2)}%");
      if (map[y][x]) continue;
      final updatedMap = map.map((row) => row.toList()).toList();
      updatedMap[y][x] = true;
      final steps = countSteps(updatedMap, initialPos);
      if (steps == null) {
        loops++;
      }
    }
  }
  return loops;
}

void main() async {
  final rawMap = (await File("day6/input").readAsLines())
      .map((line) => line.split("").toList())
      .toList();

  final initialPos = findStartPos(rawMap);

  final map =
      rawMap.map((row) => row.map((cell) => cell == "#").toList()).toList();

  final part1 = countSteps(map, initialPos);
  final part2 = introduceLoops(map, initialPos);

  print("part1: $part1");
  print("part2: $part2");
}
