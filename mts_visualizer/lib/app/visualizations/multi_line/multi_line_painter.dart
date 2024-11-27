import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mts_visualizer/app/ui_utils.dart';
import 'package:scidart/numdart.dart';

class MultiChartPainter extends CustomPainter {
  final double minValue;
  final double maxValue;
  final List<bool> isSelected;
  final List<Color> colors;
  // NxT shape
  final Array2d series;
  MultiChartPainter({
    required this.series,
    required this.minValue,
    required this.maxValue,
    required this.isSelected,
    required this.colors,
  });

  late double _width;
  late double _height;
  late Canvas _canvas;
  late double _horizontalSpace;
  Color normalColor = Color.fromRGBO(140, 140, 140, 1);
  int get timeLen => series[0].length;
  // DatasetController datasetController = Get.find();
  // DashboardController dashboardController = Get.find();
  // PollutantModel get pollutant => datasetController.projectedPollutant;

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    _width = size.width;
    _height = size.height;
    _horizontalSpace = _width / (timeLen - 1);

    for (var i = 0; i < series.length; i++) {
      if (!isSelected[i]) {
        paintModelLine(series[i], i, isSelected[i]);
      }
    }
    for (var i = 0; i < series.length; i++) {
      if (isSelected[i]) {
        paintModelLine(series[i], i, isSelected[i]);
      }
    }
  }

  void paintModelLine(Array serie, int pos, bool selected) {
    Path path = Path();

    List<double> values;
    values = serie.toList();
    // if (datasetController.showSmoothed) {
    //   values = model.data.smoothedValues[pollutant.id]!;
    // } else {
    //   values = model.data.values[pollutant.id]!;
    // }

    double value = min(values[0], maxValue);
    path.moveTo(0, value2Heigh(value));
    for (var i = 1; i < values.length; i++) {
      // print(model.values[pollutant.id]![i]);
      double value = min(values[i], maxValue);
      value = max(value, minValue);
      path.lineTo(
        i * _horizontalSpace,
        value2Heigh(value),
      );
    }

    late Paint paint;
    paint = Paint()
      ..color = isSelected[pos] ? colors[pos] : normalColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // if (model.cluster != null) {
    //   if (dashboardController.selectedPoints.isNotEmpty) {
    //     if (model.selected) {
    //       paint = Paint()
    //         ..color = uiClusterColor(model.cluster!)
    //         ..style = PaintingStyle.stroke
    //         ..strokeWidth = 1.5;
    //     } else {
    //       paint = Paint()
    //         ..color = normalColor
    //         ..style = PaintingStyle.stroke
    //         ..strokeWidth = 1.5;
    //     }
    //   } else {
    //     paint = Paint()
    //       ..color = uiClusterColor(model.cluster!).withOpacity(0.3)
    //       ..style = PaintingStyle.stroke
    //       ..strokeWidth = 1.5;
    //   }
    // } else {
    //   if (model.selected) {
    //     paint = Paint()
    //       ..color = pColorPrimary
    //       ..style = PaintingStyle.stroke
    //       ..strokeWidth = 1.5;
    //   } else {
    //     paint = Paint()
    //       ..color = normalColor
    //       ..style = PaintingStyle.stroke
    //       ..strokeWidth = 1.5;
    //   }
    // }

    if (selected) {
      // paint.color = Color.fromRGBO(0, 50, 120, 0.8);
    } else {
      // paint.color = Color.fromRGBO(120, 120, 120, 0.8);
    }

    _canvas.drawPath(
      path,
      paint,
    );
  }

  double value2Heigh(double value) {
    return _height - uiRangeConverter(value, minValue, maxValue, 0, _height);
    // return _height - (value / visSettings.datasetSettings.maxValue * _height);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
