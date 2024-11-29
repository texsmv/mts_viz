import 'dart:ffi';

import 'package:series_visualizer/classes/ndarray.dart';

class PLabels {
  late Map<int, String> labelNames;
  late List<int> y;

  List<int> get uniqueLabels {
    var seen = Set<int>();
    return y.where((label) => seen.add(label)).toList();
  }

  List<String> get uniqueLabelsNames {
    return uniqueLabels.map((label) => labelNames[label]!).toList();
  }
}

class Dataset {
  late Map<String, NDArray> projections;
  late List<String> dimensions;
  late List<int> shape;
  late Map<String, PLabels> labelsDict;

  void changeCurrLabel(String nlabel) {
    if (labelsDict.containsKey(nlabel)) {
      currLabels = nlabel;
    } else {
      throw Exception('Label $nlabel not found');
    }
  }

  Dataset.fromJson(Map<String, dynamic> objectInfo) {
    // Set shape
    shape = List<int>.from(objectInfo['shape']);

    // Initialize projections
    projections = {};
    objectInfo['projections'].forEach((key, value) {
      projections[key] = NDArray(value);
      int N = projections[key]!.shape[0];
      projections[key] = projections[key]!..reshape([N ~/ 2, 2]);
    });

    // * Initialize labelsDict
    labelsDict = {};
    objectInfo['labels'].forEach((labelKey, labelValues) {
      PLabels pLabels = PLabels();

      pLabels.y = List<int>.from(labelValues);
      pLabels.labelNames = objectInfo['labelsNames'][labelKey].map<int, String>(
        (key, value) => MapEntry<int, String>(int.parse(key), value),
      );

      labelsDict![labelKey] = pLabels;
    });

    // * Initialize dimensions
    dimensions = List<String>.from(objectInfo['dimensions']);

    // * Initialize current projection and labels
    currProjection = projections.keys.first;
    currLabels = labelsDict.keys.first;
  }

  int get n => shape[0];
  int get t => shape[1];
  int get d => shape[2];

  // selected labels
  String? currLabels;
  String? currProjection;

  // * ---------------------------  Getters --------------------------- *
  NDArray get projection => projections[currProjection]!;
  PLabels get labels => labelsDict[currLabels]!;
  List<String> get labelsOptions => labelsDict.keys.toList();
  List<String> get projectionsOptions => projections.keys.toList();
}
