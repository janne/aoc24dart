import 'dart:io';

typedef Equation = ({int testValue, List<int> numbers});

List<Equation> parseInput(List<String> input) => input.map((line) {
      final inp = line.split(": ");
      return (testValue: int.parse(inp[0]), numbers: inp[1].split(" ").map((i) => int.parse(i)).toList());
    }).toList();

int validateEquationsPart1(List<Equation> equations) => equations
    .map((equation) => equation.numbers.fold(<int>[],
            (nums, num) => nums.isEmpty ? [num] : [...nums.map((n) => n + num), ...nums.map((n) => n * num)]).any((r) => r == equation.testValue)
        ? equation.testValue
        : 0)
    .reduce((a, b) => a + b);

int validateEquationsPart2(List<Equation> equations) => equations
    .map((equation) => equation.numbers.fold(
            <int>[],
            (nums, num) => nums.isEmpty
                ? [num]
                : [
                    ...nums.map((n) => int.parse("$n$num")),
                    ...nums.map((n) => n + num),
                    ...nums.map((n) => n * num)
                  ]).any((r) => r == equation.testValue)
        ? equation.testValue
        : 0)
    .reduce((a, b) => a + b);

void main() async {
  final equations = parseInput(await File("day7/input").readAsLines());
  final part1 = validateEquationsPart1(equations);
  print("part1: $part1");

  final part2 = validateEquationsPart2(equations);
  print("part2: $part2");
}
