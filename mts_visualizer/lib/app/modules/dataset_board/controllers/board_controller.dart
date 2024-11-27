import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mts_visualizer/api/models/dataset_model.dart';
import 'package:mts_visualizer/app/controllers/datasets_controller.dart';
import 'package:mts_visualizer/app/extensions/colors.dart';
import 'package:mts_visualizer/app/extensions/list_shape_extension.dart';
import 'package:mts_visualizer/app/modules/dashboard/components/chart_placer.dart';
import 'package:mts_visualizer/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mts_visualizer/app/ui_utils.dart';
import 'package:mts_visualizer/app/visualizations/iprojection/ipoint.dart';
import 'package:mts_visualizer/app/visualizations/iprojection/iprojection_controller.dart';
import 'package:mts_visualizer/app/visualizations/multi_line/multi_line.dart';
import 'package:mts_visualizer/app/widgets/containers/pcard.dart';

class BoardController extends GetxController {
  DatasetModel? get dataset => _datasetsController.dataset(id);
  bool get coordsEnable => dataset?.coords != null;
  bool get labelsEnable => dataset?.labels != null;

  List<int>? get clusterLabels {
    return _clusterLabels;
  }

  List<String> get clusterLabelsNames {
    return List.generate(_clusterLabels!.length,
        (index) => dataset!.labelsMap![_clusterLabels![index]]!);
  }

  List<IPoint>? get ipoints {
    return _ipoints;
  }

  void onPointsSelected(List<IPoint> selected) {
    for (var i = 0; i < isSelected.length; i++) {
      isSelected[i] = false;
    }
    for (var i = 0; i < selected.length; i++) {
      isSelected[selected[i].pos] = true;
    }
    update(['selection']);
  }

  void initVariables() {
    // IPOINTS
    if (coordsEnable) {
      List<dynamic> coords = dataset!.coords!;
      _ipoints = List.generate(
        coords.length,
        (index) => IPoint(
          pos: index,
          coordinates: Offset(coords[index][0], coords[index][1]),
        ),
      );
      if (isSelected.isEmpty) {
        isSelected = List.generate(
          _ipoints!.length,
          (index) => false,
        );
      }
    } else {
      isSelected = List.generate(
        dataset!.n,
        (index) => true,
      );
    }

    // OTHERS
    if (labelsEnable) {
      var seen = Set<int>();
      List<int> uniquelist =
          dataset!.labels!.where((label) => seen.add(label)).toList();
      _clusterLabels = uniquelist;
      _clusterLabels!.sort();

      List<Color> colors =
          List.generate(_clusterLabels!.length, (index) => uiGetColor(index));

      for (var i = 0; i < colors.length; i++) {
        clusterColors[_clusterLabels![i]] = colors[i];
      }
    }

    // Generate colors for each point with a random brightness
    int brightnessRange = 40;
    print("CLuster colors");
    print(clusterColors);
    pointColors = List.generate(
      dataset!.n,
      (index) => (labelsEnable
              ? clusterColors[dataset!.labels![index]]!
              : pColorPrimary)
          .addBrightness(
              Random().nextInt(brightnessRange * 2) - brightnessRange),
    );
  }

  void updateLabelOption() {
    var seen = Set<int>();
    List<int> uniquelist =
        dataset!.labels!.where((label) => seen.add(label)).toList();
    _clusterLabels = uniquelist;
    _clusterLabels!.sort();

    List<Color> colors =
        List.generate(_clusterLabels!.length, (index) => uiGetColor(index));

    for (var i = 0; i < colors.length; i++) {
      clusterColors[_clusterLabels![i]] = colors[i];
    }

    // Generate colors for each point with a random brightness
    int brightnessRange = 40;
    pointColors = List.generate(
      dataset!.n,
      (index) => (labelsEnable
              ? clusterColors[dataset!.labels![index]]!
              : pColorPrimary)
          .addBrightness(
              Random().nextInt(brightnessRange * 2) - brightnessRange),
    );
    update(['selection']);
    update();
  }

  updateCoordsOption(String coordsLabel) {
    dataset!.scoord = coordsLabel;

    List<dynamic> coords = dataset!.coords!;
    _ipoints = List.generate(
      coords.length,
      (index) => IPoint(
        pos: index,
        coordinates: Offset(coords[index][0], coords[index][1]),
      ),
    );
    if (isSelected.isEmpty) {
      isSelected = List.generate(
        _ipoints!.length,
        (index) => false,
      );
    }

    update(['selection']);
    update();
  }

  void selectDimension(int label) {
    for (var i = 0; i < dataset!.labels!.length; i++) {
      isSelected[i] = dataset!.labels![i] == label;
      if (coordsEnable) {
        ipoints![i].selected = dataset!.labels![i] == label;
      }
    }
    update(['selection']);
    update();
  }

  void createGrid() {
    gridContent = List.generate(
      nrows,
      (i) => List.generate(ncols, (j) => null),
    );

    grid = List.generate(
      nrows,
      (i) => List.generate(
        ncols,
        (j) => ChartPlacer(
          // key: Key('${i}-${j}'),
          boardId: id,
          row: i,
          col: j,
          child: gridContent[i][j],
        ),
      ),
    );
  }

  final String id;
  BoardController({required this.id});

  @override
  void onInit() {
    createGrid();
    projectionController =
        Get.put(IProjectionController(boardId: id), tag: id, permanent: true);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void addChart(int dimPos) {
    gridContent[sRow][sCol] = MultiLine(
      boardId: id,
      series: dataset!.getDimension(dimPos),
      isSelected: isSelected,
      title: dataset!.dimensions[dimPos],
    );
    grid[sRow][sCol] = ChartPlacer(
      boardId: id,
      row: sRow,
      col: sCol,
      child: gridContent[sRow][sCol],
    );
    update();
  }

  final DatasetsController _datasetsController = Get.find();

  int nrows = 2;
  int ncols = 3;

  int sRow = 0;
  int sCol = 0;
  late List<List<Widget>> grid;
  late List<List<Widget?>> gridContent;
  List<int>? _clusterLabels;
  Map<int, Color> clusterColors = {};
  List<IPoint>? _ipoints;
  // size of _ipoints
  List<bool> isSelected = [];
  late List<Color> pointColors;
  late IProjectionController projectionController;
}
