import 'dart:io';

import 'package:collection/collection.dart';

void main() async {
  final lines = await File("day1/input").readAsLines();
  final (a, b) = lines.map((line) => line.split(RegExp(r"\s+")).map((s) => int.parse(s))).fold<(List<int>, List<int>)>(([], []), ((lists, nums) {
    final (a, b) = lists;
    return ([...a, nums.elementAt(0)], [...b, nums.elementAt(1)]);
  }));
  final part1 = IterableZip([a..sort(), b..sort()]).map((nums) => (nums[0] - nums[1]).abs()).reduce((a, b) => a + b);
  print("part1: $part1");

  final part2 = a.map((num) => num * b.where(((num2) => num2 == num)).length).reduce((a, b) => a + b);
  print("part2: $part2");
}
