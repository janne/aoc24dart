import 'dart:io';

typedef Pos = ({int x, int y, Direction direction});

typedef Map = List<List<bool>>;

enum Direction { up, right, down, left }

Pos findStartPos(List<List<String>> map) {
  for (int y = 0; y < map.length; y++) {
    for (int x = 0; x < map.first.length; x++) {
      if (map[y][x] == "^") return (x: x, y: y, direction: Direction.up);
    }
  }

  throw Exception("No start position found");
}

bool isInsideMap(Pos pos, Map map) {
  return pos.x >= 0 && pos.x < map.first.length && pos.y >= 0 && pos.y < map.length;
}

Pos? advancePos(Pos pos, Map map) {
  final newPos = switch (pos.direction) {
    Direction.up => (x: pos.x, y: pos.y - 1, direction: pos.direction),
    Direction.right => (x: pos.x + 1, y: pos.y, direction: pos.direction),
    Direction.down => (x: pos.x, y: pos.y + 1, direction: pos.direction),
    Direction.left => (x: pos.x - 1, y: pos.y, direction: pos.direction),
  };

  if (!isInsideMap(newPos, map)) return null;

  if (!map[newPos.y][newPos.x]) return newPos;

  final newDirection = switch (pos.direction) {
    Direction.up => Direction.right,
    Direction.right => Direction.down,
    Direction.down => Direction.left,
    Direction.left => Direction.up,
  };
  return (x: pos.x, y: pos.y, direction: newDirection);
}

Direction advanceDirection(Map map, Pos pos, Direction direction) {
  if (!map[pos.y][pos.x]) return direction;
  return switch (direction) {
    Direction.up => Direction.right,
    Direction.right => Direction.down,
    Direction.down => Direction.left,
    Direction.left => Direction.up,
  };
}

int? countSteps(Map map, Pos initialPos) {
  final visited = <Pos>{};
  Pos pos = initialPos;

  while (true) {
    if (visited.any((p) => pos == p)) {
      return null;
    }
    visited.add(pos);
    final newPos = advancePos(pos, map);
    if (newPos == null) {
      break;
    }
    pos = newPos;
  }
  return visited.fold(<(int, int)>{}, (memo, pos) => {...memo, (pos.x, pos.y)}).length;
}

int? introduceLoops(Map map, Pos initialPos, int totalSteps) {
  final loops = <(int, int)>{};
  Pos pos = initialPos;
  pos = advancePos(pos, map)!;
  int i = 0;
  while (true) {
    i++;
    print("Step: ${(i / totalSteps * 100).toStringAsFixed(2)}%, so far: ${loops.length}");
    final nextPos = advancePos(pos, map);
    if (nextPos == null) break;
    pos = nextPos;
    final newMap = map.map((row) => row.toList()).toList();
    newMap[pos.y][pos.x] = true;
    final steps = countSteps(newMap, initialPos);
    if (steps == null) {
      loops.add((pos.x, pos.y));
    }
  }
  return loops.length;
}

void main() async {
  final rawMap = (await File("day6/input").readAsLines()).map((line) => line.split("").toList()).toList();

  final initialPos = findStartPos(rawMap);

  final map = rawMap.map((row) => row.map((cell) => cell == "#").toList()).toList();

  final part1 = countSteps(map, initialPos);
  final part2 = introduceLoops(map, initialPos, part1!);

  print("part1: $part1");
  print("part2: $part2");
}
