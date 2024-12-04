import 'dart:io';

import 'package:collection/collection.dart';

List<List<int>> parseRules(List<String> rules) => rules
    .map((rule) => rule.split("|").map((i) => int.parse(i)).toList())
    .toList();

Map<int, List<int>> buildRuleMap(List<List<int>> rules) => rules.fold(
    <int, List<int>>{},
    (memo, rule) => {
          ...memo,
          rule[1]: [...(memo[rule[1]] ?? {}), rule[0]]
        });

List<List<int>> parseUpdates(List<String> updates) => updates
    .map((update) => update.split(",").map((i) => int.parse(i)).toList())
    .toList();

int middleValue(List<int> values) => values[values.length ~/ 2];

bool isValidUpdate(Map<int, List<int>> rules, List<int> update) {
  for (int i = 0; i < update.length; i++) {
    for (int j = i + 1; j < update.length; j++) {
      if (rules[update[i]]?.contains(update[j]) ?? false) {
        return false;
      }
    }
  }
  return true;
}

List<int> sortUpdates(Map<int, List<int>> rules, List<int> update) {
  return update.sorted((a, b) => (rules[a] ?? []).contains(b) ? -1 : 1);
}

void main() async {
  final input = (await File("day5/input").readAsString()).split("\n\n");
  final rules = parseRules(input[0].split("\n"));
  final ruleMap = buildRuleMap(rules);
  final updates = parseUpdates(input[1].split("\n"));

  final part1 = updates
      .map((update) => isValidUpdate(ruleMap, update) ? middleValue(update) : 0)
      .reduce((a, b) => a + b);

  print("part1: $part1");

  final part2 = updates
      .where((update) => !isValidUpdate(ruleMap, update))
      .map((update) => sortUpdates(ruleMap, update))
      .map((update) => middleValue(update))
      .reduce((a, b) => a + b);

  print("part2: $part2");
}
