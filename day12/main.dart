import 'dart:io';

import 'package:collection/collection.dart';

typedef Plant = ({int x, int y, String id});

typedef Region = List<Plant>;

List<Plant> aroundPlant(Plant plant) => [
      (x: plant.x, y: plant.y - 1, id: plant.id),
      (x: plant.x + 1, y: plant.y, id: plant.id),
      (x: plant.x, y: plant.y + 1, id: plant.id),
      (x: plant.x - 1, y: plant.y, id: plant.id),
    ];

List<T> intersecting<T>(List<T> list1, List<T> list2) => list1.where((T t) => list2.contains(t)).toList();

bool isIntersecting<T>(List<T> list1, List<T> list2) => list1.any((T t) => list2.contains(t));

// My version, worked with test input but not real input
// List<Region> parseRegions(List<Plant> plants) {
//   final List<Region> regions = [];
//   for (final plant in plants) {
//     final around = aroundPlant(plant);
//     final region = regions.firstWhereOrNull((region) => isIntersecting(region, around));
//     if (region != null) {
//       region.add(plant);
//     } else {
//       regions.add([plant]);
//     }
//   }
//   final List<Region> result = [];
//   for (int i = 0; i < regions.length; i++) {
//     final region = regions[i];
//     final overlapIndex = result.indexWhere((resultRegion) => resultRegion.any((p) => isIntersecting(region, aroundPlant(p))));
//     if (overlapIndex == -1) {
//       result.add(region);
//     } else {
//       result[overlapIndex].addAll(region);
//     }
//   }
//   return result;
// }

// AI solution (ChatGPT o1), way faster and correct
List<Region> parseRegions(List<Plant> plants) {
  final regions = <Region>[];

  // Map of coordinates to Plant for quick lookups
  final plantMap = <(int, int), Plant>{for (final p in plants) (p.x, p.y): p};

  // Set of visited coordinates
  final visited = <(int, int)>{};

  // Directions for neighbors: up, right, down, left
  const directions = [(0, -1), (1, 0), (0, 1), (-1, 0)];

  // DFS function to explore all connected plants of the same id
  void dfs(Plant start, Region region) {
    final stack = <Plant>[start];
    visited.add((start.x, start.y));

    while (stack.isNotEmpty) {
      final current = stack.removeLast();
      region.add(current);

      // Explore neighbors
      for (final (dx, dy) in directions) {
        final nx = current.x + dx;
        final ny = current.y + dy;
        final neighborKey = (nx, ny);

        if (!visited.contains(neighborKey) && plantMap.containsKey(neighborKey)) {
          final neighbor = plantMap[neighborKey]!;
          // Only add neighbors with the same plant id
          if (neighbor.id == current.id) {
            visited.add(neighborKey);
            stack.add(neighbor);
          }
        }
      }
    }
  }

  // Find all regions
  for (final plant in plants) {
    if (!visited.contains((plant.x, plant.y))) {
      final region = <Plant>[];
      dfs(plant, region);
      regions.add(region);
    }
  }

  return regions;
}

List<Plant> parsePlants(List<List<String>> input) {
  final List<Plant> plants = [];
  for (int y = 0; y < input.length; y++) {
    for (int x = 0; x < input.first.length; x++) {
      plants.add((x: x, y: y, id: input[y][x]));
    }
  }
  return plants;
}

int perimeter(List<Plant> plants) {
  return plants.map((plant) {
    final neighbours = intersecting(aroundPlant(plant), plants);
    return 4 - neighbours.length;
  }).reduce((int a, int b) => a + b);
}

void main() async {
  final input = (await File("day12/input").readAsLines()).map((line) => line.split("").toList()).toList();
  final plants = parsePlants(input);
  final regions = parseRegions(plants);
  final part1 = regions.map((region) => region.length * perimeter(region)).reduce((a, b) => a + b);
  print("part1: $part1");
}
