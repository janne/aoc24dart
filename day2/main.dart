import 'dart:io';

List<int> calculateGaps(List<int> list) => list.fold<(List<int>, int?)>(([], null), (memo, last) {
      final (increases, prev) = memo;
      return prev == null ? ([], last) : ([last - prev, ...increases], last);
    }).$1;

bool isSafe(List<int> line) {
  final gaps = calculateGaps(line);
  return gaps.every((v) => v > 0 && v <= 3) || gaps.every((v) => v < 0 && v >= -3);
}

bool isSafeWithDebounce(List<int> line) {
  if (isSafe(line)) return true;
  for (int i = 0; i < line.length; i++) {
    final testLine = [...line]..removeAt(i);
    if (isSafe(testLine)) return true;
  }
  return false;
}

void main() async {
  final lines = (await File('day2/input').readAsLines()).map((line) => line.split(" ").map((n) => int.parse(n)).toList()).toList();

  final part1 = lines.map(isSafe).where((v) => v).length;
  print("part1: $part1");

  final part2 = lines.map(isSafeWithDebounce).where((v) => v).length;
  print("part2: $part2");
}
