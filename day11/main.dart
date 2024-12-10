import 'dart:io';

void main() async {
  final input = await File("day11/test_input").readAsLines();

  final part1 = input.length;
  print("part1: $part1");
}
