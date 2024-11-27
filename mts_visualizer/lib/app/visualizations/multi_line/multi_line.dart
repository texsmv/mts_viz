import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mts_visualizer/app/extensions/colors.dart';
import 'package:mts_visualizer/app/modules/dataset_board/controllers/board_controller.dart';
import 'package:mts_visualizer/app/ui_utils.dart';
import 'package:mts_visualizer/app/visualizations/axis.dart';
import 'package:mts_visualizer/app/visualizations/multi_line/multi_line_painter.dart';
import 'package:mts_visualizer/app/widgets/buttons/pButton.dart';
import 'package:mts_visualizer/app/widgets/containers/pdialog.dart';
import 'package:scidart/numdart.dart';

class MultiLine extends StatefulWidget {
  // NxT shape
  final String? title;
  final Array2d series;
  final List<bool> isSelected;
  // final List<Color> colors;
  final String boardId;
  const MultiLine({
    Key? key,
    required this.boardId,
    required this.series,
    required this.isSelected,
    // required this.colors,
    this.title,
  }) : super(key: key);

  @override
  State<MultiLine> createState() => _MultiLineState();
}

class _MultiLineState extends State<MultiLine> {
  late double minV;
  late double maxV;

  @override
  void initState() {
    super.initState();
    minV = arrayMin(Array(
      List.generate(
        widget.series.length,
        (index) => arrayMin(widget.series[index]),
      ),
    ));

    maxV = arrayMax(Array(
      List.generate(
        widget.series.length,
        (index) => arrayMax(widget.series[index]),
      ),
    ));
  }

  @override
  void didUpdateWidget(covariant MultiLine oldWidget) {
    if (oldWidget.series.first.first != widget.series.first.first) {
      minV = arrayMin(Array(
        List.generate(
          widget.series.length,
          (index) => arrayMin(widget.series[index]),
        ),
      ));

      maxV = arrayMax(Array(
        List.generate(
          widget.series.length,
          (index) => arrayMax(widget.series[index]),
        ),
      ));
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                widget.title != null
                    ? Text(
                        widget.title!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: pColorSecondary,
                        ),
                      )
                    : const SizedBox(),
                GestureDetector(
                  onTap: () async {
                    Get.dialog(
                      PDialog(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          width: 400,
                          height: 300,
                          // ask for a number input
                          child: Column(
                            children: [
                              Text("Min"),
                              TextField(
                                onChanged: (value) {
                                  minV = double.parse(value);
                                },
                              ),
                              Text("Max"),
                              TextField(
                                onChanged: (value) {
                                  maxV = double.parse(value);
                                },
                              ),
                              PButton(
                                text: 'Ok',
                                onTap: () {
                                  setState(() {});
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      barrierColor: Colors.transparent,
                    );
                  },
                  child: Icon(
                    Icons.settings,
                  ),
                ),
              ],
            ),
            Expanded(
              child: LeftAxis(
                xAxisLabel: 'x',
                xMaxValue: widget.series[0].length.toDouble(),
                xMinValue: 0,
                xDivisions: 5,
                yMaxValue: maxV,
                yMinValue: minV,
                yAxisLabel: 'y',
                yDivisions: 5,
                child: GetBuilder<BoardController>(
                  tag: widget.boardId,
                  id: 'selection',
                  builder: (boarC) => CustomPaint(
                    painter: MultiChartPainter(
                      series: widget.series,
                      isSelected: widget.isSelected,
                      minValue: minV,
                      maxValue: maxV,
                      colors: boarC.pointColors,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MeanStdChartPainter extends CustomPainter {
  final double minValue;
  final double maxValue;
  final List<bool> isSelected;
  final List<Color> colors;
  final Array2d series;

  MeanStdChartPainter({
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

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    _width = size.width;
    _height = size.height;
    _horizontalSpace = _width / (timeLen - 1);

    List<double> means = [];
    List<double> stds = [];

    for (int i = 0; i < timeLen; i++) {
      List<double> valuesAtTime = [];
      for (int j = 0; j < series.length; j++) {
        valuesAtTime.add(series[j][i]);
      }
      double mean = valuesAtTime.reduce((a, b) => a + b) / valuesAtTime.length;
      double std = sqrt(
          valuesAtTime.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) /
              valuesAtTime.length);
      means.add(mean);
      stds.add(std);
    }

    Path meanPath = Path();
    Path stdPathUpper = Path();
    Path stdPathLower = Path();

    meanPath.moveTo(0, value2Height(means[0]));
    stdPathUpper.moveTo(0, value2Height(means[0] + stds[0]));
    stdPathLower.moveTo(0, value2Height(means[0] - stds[0]));

    for (int i = 1; i < timeLen; i++) {
      meanPath.lineTo(i * _horizontalSpace, value2Height(means[i]));
      stdPathUpper.lineTo(
          i * _horizontalSpace, value2Height(means[i] + stds[i]));
      stdPathLower.lineTo(
          i * _horizontalSpace, value2Height(means[i] - stds[i]));
    }

    Paint meanPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    Paint stdPaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    _canvas.drawPath(meanPath, meanPaint);
    _canvas.drawPath(stdPathUpper, stdPaint);
    _canvas.drawPath(stdPathLower, stdPaint);
  }

  double value2Height(double value) {
    return _height - uiRangeConverter(value, minValue, maxValue, 0, _height);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
