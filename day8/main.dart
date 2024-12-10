import 'dart:io';

typedef Pos = ({int x, int y});

typedef Antennas = Map<String, List<Pos>>;

Antennas parseInput(List<List<String>> input) {
  final Antennas antennas = {};
  for (var y = 0; y < input.length; y++) {
    final row = input[y];
    for (var x = 0; x < row.length; x++) {
      if (row[x] != ".") {
        antennas[row[x]] = [...(antennas[row[x]] ?? []), (x: x, y: y)];
      }
    }
  }
  return antennas;
}

Iterable<(T, T)> findPermuations<T>(List<T> list) sync* {
  for (var i = 0; i < list.length; i++) {
    for (var j = i + 1; j < list.length; j++) {
      yield (list[i], list[j]);
    }
  }
}

(Pos, Pos) scalePoints(Pos p1, Pos p2, {scaleFactor = 3.0}) {
  final midX = (p1.x + p2.x) / 2;
  final midY = (p1.y + p2.y) / 2;
  final dx = (p1.x - midX) * scaleFactor;
  final dy = (p1.y - midY) * scaleFactor;
  return ((x: (midX + dx).round(), y: (midY + dy).round()), (x: (midX - dx).round(), y: (midY - dy).round()));
}

bool isWithinMax(Pos p, Pos max) {
  return p.x >= 0 && p.y >= 0 && p.x < max.x && p.y < max.y;
}

Set<Pos> findAntinodesPart1(Antennas antennas, Pos max) {
  final Set<Pos> antinodes = {};
  antennas.keys.forEach((freq) {
    for (var (Pos p1, Pos p2) in findPermuations<Pos>(antennas[freq]!)) {
      final (s1, s2) = scalePoints(p1, p2);
      for (Pos p in [s1, s2]) {
        if (isWithinMax(p, max)) {
          antinodes.add(p);
        }
      }
    }
  });
  return antinodes;
}

Set<Pos> repeatAntinodes(Pos pos1, Pos pos2, Pos max) {
  final positions = <Pos>{};
  Pos p1 = pos1;
  Pos p2 = pos2;
  double scaleFactor = 3;
  while (isWithinMax(p1, max) || isWithinMax(p2, max)) {
    if (isWithinMax(p1, max)) {
      positions.add(p1);
    }
    if (isWithinMax(p2, max)) {
      positions.add(p2);
    }
    (p1, p2) = scalePoints(pos1, pos2, scaleFactor: scaleFactor);
    scaleFactor += 2;
  }
  return positions;
}

Set<Pos> findAntinodesPart2(Antennas antennas, Pos max) {
  final Set<Pos> antinodes = {};
  antennas.keys.forEach((freq) {
    final permutations = findPermuations<Pos>(antennas[freq]!);
    for (var (Pos p1, Pos p2) in permutations) {
      for (Pos p in repeatAntinodes(p1, p2, max)) {
        antinodes.add(p);
      }
    }
  });
  return antinodes;
}

void main() async {
  final input = (await File("day8/input").readAsLines()).map((line) => line.split("").toList()).toList();

  final antennas = parseInput(input);

  final antinodesPart1 = findAntinodesPart1(antennas, (x: input.first.length, y: input.length));
  print("part1: ${antinodesPart1.length}");

  final antinodesPart2 = findAntinodesPart2(antennas, (x: input.first.length, y: input.length));
  print("part2: ${antinodesPart2.length}");
}
