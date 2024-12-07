import 'dart:io';

typedef Equation = ({int testValue, List<int> numbers});

List<Equation> parseInput(List<String> input) => input.map((line) {
      final inp = line.split(": ");
      return (
        testValue: int.parse(inp[0]),
        numbers: inp[1].split(" ").map((i) => int.parse(i)).toList()
      );
    }).toList();

List<int> validateEquationsPart1(List<Equation> equations) {
  return equations.map((equation) {
    final results = equation.numbers.fold(
        <int>[],
        (nums, num) => nums.isEmpty
            ? [num]
            : [...nums.map((n) => n + num), ...nums.map((n) => n * num)]);
    return results.any((r) => r == equation.testValue) ? equation.testValue : 0;
  }).toList();
}

List<int> validateEquationsPart2(List<Equation> equations) {
  return equations.map((equation) {
    final results = equation.numbers.fold(
        <int>[],
        (nums, num) => nums.isEmpty
            ? [num]
            : [
                ...nums.map((n) => int.parse("$n$num")),
                ...nums.map((n) => n + num),
                ...nums.map((n) => n * num)
              ]);
    return results.any((r) => r == equation.testValue) ? equation.testValue : 0;
  }).toList();
}

void main() async {
  final equations = parseInput(await File("day7/input").readAsLines());
  final part1 = validateEquationsPart1(equations).reduce((a, b) => a + b);
  print("part1: $part1");

  final part2 = validateEquationsPart2(equations).reduce((a, b) => a + b);
  print("part2: $part2");
}
