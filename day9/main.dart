import 'dart:io';

List<int?> expandInput(List<String> input) {
  bool space = true;
  int id = 0;
  return input.expand((len) {
    space = !space;
    if (space) {
      return List.filled(int.parse(len), null);
    } else {
      final fileId = id++;
      return List.filled(int.parse(len), fileId);
    }
  }).toList();
}

int calculateChecksum(List<int> list) => list
    .asMap()
    .entries
    .map((entry) => entry.key * entry.value)
    .reduce((a, b) => a + b);

List<int> moveItemsPart1(List<int?> list) {
  int moved = 0;
  List<int> result = [];
  for (int i = 0; i < list.length - moved; i++) {
    if (list[i] != null) {
      result.add(list[i]!);
    } else {
      while (list[list.length - moved - 1] == null) {
        moved++;
      }
      if (i < list.length - moved) {
        final value = list[list.length - moved - 1]!;
        result.add(value);
        moved++;
      }
    }
  }
  return result;
}

List<int?> moveItemsPart2(List<int?> list) {
  int id = list.fold(0, (max, i) => (i ?? 0) > max ? i! : max);
  while (id >= 0) {
    final start = list.indexOf(id);
    final length = list.lastIndexOf(id) - start + 1;
    for (int i = 0; i < start; i++) {
      if (list.sublist(i, i + length).every((i) => i == null)) {
        list.replaceRange(i, i + length, List.filled(length, id));
        list.replaceRange(start, start + length, List.filled(length, null));
        break;
      }
    }
    id--;
  }
  return list;
}

void main() async {
  final input = (await File("day9/input").readAsString()).split("").toList();
  final expanded = expandInput(input);
  final movedPart1 = moveItemsPart1(expanded);
  final part1 = calculateChecksum(movedPart1);
  print("part1: $part1");
  final movedPart2 = moveItemsPart2(expanded);
  final part2 = calculateChecksum(movedPart2.map((i) => i ?? 0).toList());
  print("part2: $part2");
}
