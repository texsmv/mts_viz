import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:series_visualizer/app/visualizations/ts_std_bars/ts_std_bars_painter.dart';

class StdChart extends StatefulWidget {
  final List<double>? selectedMeans;
  final List<double>? selectedStds;
  final List<double> allMeans;
  final List<double> allStds;
  final Color colorAll;
  final Color colorSelected;
  const StdChart({
    Key? key,
    this.selectedMeans,
    this.selectedStds,
    required this.allMeans,
    required this.allStds,
    required this.colorAll,
    required this.colorSelected,
  }) : super(key: key);

  @override
  State<StdChart> createState() => _StdChartState();
}

class _StdChartState extends State<StdChart> {
  late double minValue;
  late double maxValue;

  int get timeLen => widget.allMeans.length;

  @override
  void initState() {
    updateRanges();
    super.initState();
  }

  @override
  void didUpdateWidget(StdChart oldWidget) {
    print("didUpdateWidget");
    super.didUpdateWidget(oldWidget);
    // if (widget.selectedMeans != null && oldWidget.selectedMeans != null) {
    if (oldWidget == null ||
        widget.selectedMeans == null ||
        oldWidget.selectedMeans == null) {
      return;
    }
    //  Compare wheter the values in selectedMeans have changed
    if (widget.selectedMeans!.asMap().entries.every((entry) {
          return entry.value == oldWidget.selectedMeans![entry.key];
        }) &&
        widget.selectedStds!.asMap().entries.every((entry) {
          return entry.value == oldWidget.selectedStds![entry.key];
        })) {
      updateRanges();
    }

    // if (widget.selectedMeans!.length != oldWidget.selectedMeans!.length) {
    // print("updateRanges");
    // print(widget.selectedMeans!.length);
    // }
    // }
  }

  void updateRanges() {
    int std_range = 4;
    // means + stds
    List<double> means = widget.allMeans;
    List<double> stds = widget.allStds;
    List<double> maxValues = List.generate(timeLen, (index) {
      return means[index] + (stds[index] * std_range);
    });
    List<double> minValues = List.generate(timeLen, (index) {
      return means[index] - (stds[index] * std_range);
    });

    minValue = minValues.reduce(min);
    maxValue = maxValues.reduce(max);

    if (widget.selectedMeans != null && widget.selectedStds != null) {
      List<double> selectedMeans = widget.selectedMeans!;
      List<double> selectedStds = widget.selectedStds!;
      List<double> selectedMaxValues = List.generate(timeLen, (index) {
        return selectedMeans[index] + (selectedStds[index] * std_range);
      });
      List<double> selectedMinValues = List.generate(timeLen, (index) {
        return selectedMeans[index] - (selectedStds[index] * std_range);
      });

      double selectedMinValue = selectedMinValues.reduce(min);
      double selectedMaxValue = selectedMaxValues.reduce(max);

      if (selectedMinValue < minValue) {
        minValue = selectedMinValue;
      }
      if (selectedMaxValue > maxValue) {
        maxValue = selectedMaxValue;
      }
    }
    print(minValue);
    print(maxValue);
    // Call setState after one second
    // Future.delayed(Duration(seconds: 1), () {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    updateRanges();
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: StdChartPainter(
          color: widget.colorAll,
          means: widget.allMeans,
          stds: widget.allStds,
          minV: minValue,
          maxV: maxValue,
        ),
        foregroundPainter:
            widget.selectedMeans != null && widget.selectedStds != null
                ? StdChartPainter(
                    color: widget.colorSelected,
                    means: widget.selectedMeans!,
                    stds: widget.selectedStds!,
                    minV: minValue,
                    maxV: maxValue,
                  )
                : null,
      ),
    );
  }
}
