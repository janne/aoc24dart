import 'dart:io';

final Map<String, int> cache = {};

String cacheKey(String n, int iteration) => "$n-$iteration";

int cacheResult(String key, int result) {
  cache[key] = result;
  return result;
}

int countStones(String n, int iteration) {
  if (iteration == 0) {
    return 1;
  }

  if (cache.containsKey(cacheKey(n, iteration))) {
    return cache[cacheKey(n, iteration)]!;
  }

  if (n == "0") {
    return cacheResult(cacheKey(n, iteration), countStones("1", iteration - 1));
  }

  final length = n.length;
  if (length % 2 == 0) {
    final half = length ~/ 2;
    final left = int.parse(n.substring(0, half)).toString();
    final right = int.parse(n.substring(half)).toString();
    return cacheResult(cacheKey(n, iteration), countStones(left, iteration - 1) + countStones(right, iteration - 1));
  }

  return cacheResult(cacheKey(n, iteration), countStones((int.parse(n) * 2024).toString(), iteration - 1));
}

void main() async {
  final input = (await File("day11/input").readAsString()).split(" ");

  final part1 = input.map((stone) => countStones(stone, 25)).reduce((a, b) => a + b);
  print("part1: $part1");

  final part2 = input.map((stone) => countStones(stone, 75)).reduce((a, b) => a + b);
  print("part2: $part2");
}
