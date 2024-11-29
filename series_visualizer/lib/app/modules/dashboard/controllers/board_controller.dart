import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:series_visualizer/app/colors.dart';
import 'package:series_visualizer/app/data/data_fetchers.dart';
import 'package:series_visualizer/app/modules/dashboard/components/chart_placer.dart';
import 'package:series_visualizer/app/ui_utils.dart';
import 'package:series_visualizer/app/visualizations/iprojection/ipoint.dart';
import 'package:series_visualizer/app/visualizations/iprojection/iprojection_controller.dart';
import 'package:series_visualizer/app/visualizations/ts_std_bars/ts_std_bars.dart';
import 'package:series_visualizer/classes/dataset.dart';
import 'package:series_visualizer/classes/ndarray.dart';
import 'package:series_visualizer/datasets_controller.dart';

class BoardController extends GetxController {
  late Dataset dataset;

  BoardController({required this.id, required this.dataset});

  List<int>? get clusterLabels {
    return dataset?.labels?.uniqueLabels;
  }

  List<String> get clusterLabelsNames {
    return dataset!.labels!.uniqueLabelsNames;
  }

  List<IPoint>? get ipoints {
    return _ipoints;
  }

  void onPointsSelected(List<IPoint> selected) {
    selectedPositions = [];
    for (var i = 0; i < isSelected.length; i++) {
      isSelected[i] = false;
    }
    for (var i = 0; i < selected.length; i++) {
      isSelected[selected[i].pos] = true;
      selectedPositions.add(selected[i].pos);
    }
    update(['selection']);
  }

  void initVariables() {
    // IPOINTS
    NDArray coords = dataset!.projection;
    _ipoints = List.generate(
      coords.shape[0],
      (index) => IPoint(
        pos: index,
        coordinates: Offset(coords.data[index][0], coords.data[index][1]),
      ),
    );
    if (isSelected.isEmpty) {
      isSelected = List.generate(
        _ipoints!.length,
        (index) => false,
      );
    }

    // OTHERS
    var seen = Set<int>();
    List<int> uniquelist =
        dataset!.labels!.y.where((label) => seen.add(label)).toList();
    _clusterLabels = uniquelist;
    _clusterLabels!.sort();

    List<Color> colors =
        List.generate(_clusterLabels!.length, (index) => uiGetColor(index));

    for (var i = 0; i < colors.length; i++) {
      clusterColors[_clusterLabels![i]] = colors[i];
    }

    // Generate colors for each point with a random brightness
    int brightnessRange = 40;
    print("CLuster colors");
    print(clusterColors);
    pointColors = List.generate(
      dataset!.n,
      (index) => clusterColors[dataset.labels.y[index]]!.addBrightness(
          Random().nextInt(brightnessRange * 2) - brightnessRange),
    );
  }

  void updateLabelOption() {
    var seen = Set<int>();
    List<int> uniquelist =
        dataset!.labels!.y!.where((label) => seen.add(label)).toList();
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
      (index) => clusterColors[dataset.labels.y[index]]!.addBrightness(
          Random().nextInt(brightnessRange * 2) - brightnessRange),
    );
    update(['selection']);
    update();
  }

  updateCoordsOption(String coordsLabel) {
    dataset!.currProjection = coordsLabel;

    NDArray coords = dataset!.projection;
    _ipoints = List.generate(
      coords.length,
      (index) => IPoint(
        pos: index,
        coordinates: Offset(coords.data[index][0], coords.data[index][1]),
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

  void selectLabel(int label) {
    for (var i = 0; i < dataset!.labels!.y!.length; i++) {
      isSelected[i] = dataset!.labels!.y![i] == label;
      ipoints![i].selected = dataset!.labels!.y![i] == label;
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

  @override
  void onInit() {
    createGrid();
    projectionController =
        Get.put(IProjectionController(datasetId: id), tag: id, permanent: true);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void addChart(int dimPos) {
    gridContent[sRow][sCol] = TSMeanStdFetcher(
      datasetId: id,
      dimensionPosition: dimPos,
      builder: (TSMeanStdData tsdata) {
        return StdChart(
          // key: Key('stdchart-$dimPos'),
          colorAll: pColorGray,
          colorSelected: pColorPrimary,
          allMeans: tsdata.allMean,
          allStds: tsdata.allStd,
          selectedMeans: tsdata.selectionMean,
          selectedStds: tsdata.selectionStd,
        );
      },
    );
    ;

    //  MultiLine(
    //   boardId: id,
    //   series: dataset!.getDimension(dimPos),
    //   isSelected: isSelected,
    //   title: dataset!.dimensions[dimPos],
    // );
    grid[sRow][sCol] = ChartPlacer(
      boardId: id,
      row: sRow,
      col: sCol,
      child: gridContent[sRow][sCol],
    );
    update();
  }

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
  List<int> selectedPositions = [];
  late List<Color> pointColors;
  late IProjectionController projectionController;
}
