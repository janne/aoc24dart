import 'dart:io';

List<String> pickWords1(int xStart, int yStart, List<List<String>> input) {
  final height = input.length;
  final width = input.first.length;
  final words = List.filled(8, "");
  int x = 0;
  int y = 0;

  for (int i = 0; i < 4; i++) {
    // Up
    x = xStart;
    y = yStart - i;
    if (x >= 0 && y >= 0 && x < width && y < height) {
      words[0] += input[y][x];
    }

    // Up Right
    x = xStart + i;
    y = yStart - i;
    if (x >= 0 && y >= 0 && x < width && y < height) {
      words[1] += input[y][x];
    }

    // Right
    x = xStart + i;
    y = yStart;
    if (x >= 0 && y >= 0 && x < width && y < height) {
      words[2] += input[y][x];
    }

    // Down Right
    x = xStart + i;
    y = yStart + i;
    if (x >= 0 && y >= 0 && x < width && y < height) {
      words[3] += input[y][x];
    }

    // Down
    x = xStart;
    y = yStart + i;
    if (x >= 0 && y >= 0 && x < width && y < height) {
      words[4] += input[y][x];
    }

    // Down Left
    x = xStart - i;
    y = yStart + i;
    if (x >= 0 && y >= 0 && x < width && y < height) {
      words[5] += input[y][x];
    }

    // Left
    x = xStart - i;
    y = yStart;
    if (x >= 0 && y >= 0 && x < width && y < height) {
      words[6] += input[y][x];
    }

    // Up Left
    x = xStart - i;
    y = yStart - i;
    if (x >= 0 && y >= 0 && x < width && y < height) {
      words[7] += input[y][x];
    }
  }

  return words;
}

List<String> pickWords2(int x, int y, List<List<String>> input) {
  final height = input.length;
  final width = input.first.length;
  if (x >= 1 && y >= 1 && x < width - 1 && y < height - 1) {
    final word1 = input[y - 1][x - 1] + input[y][x] + input[y + 1][x + 1];
    final word2 = input[y + 1][x - 1] + input[y][x] + input[y - 1][x + 1];
    return [word1, word2];
  }
  return [];
}

int countXmas2(List<List<String>> input) {
  int count = 0;
  for (var y = 0; y < input.length; y++) {
    final row = input[y];
    for (var x = 0; x < row.length; x++) {
      final words = pickWords2(x, y, input)
          .where((word) => word == "MAS" || word == "SAM");
      count += words.length == 2 ? 1 : 0;
    }
  }
  return count;
}

int countXmas1(List<List<String>> input) {
  int count = 0;
  for (var y = 0; y < input.length; y++) {
    final row = input[y];
    for (var x = 0; x < row.length; x++) {
      final words = pickWords1(x, y, input);
      count += words.where((word) => word == "XMAS").length;
    }
  }
  return count;
}

void main() async {
  final input = (await File("day4/input").readAsLines())
      .map((line) => line.split(""))
      .toList();

  final part1 = countXmas1(input);
  print("part1: $part1");

  final part2 = countXmas2(input);
  print("part2: $part2");
}
