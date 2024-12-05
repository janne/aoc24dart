import 'dart:io';

void main() async {
  final input = await File("day6/test_input").readAsString();

  final part1 = input.length;
  print("part1: $part1");
}
