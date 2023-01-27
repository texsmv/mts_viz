import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mts_visualizer/app/extensions/colors.dart';
import 'package:mts_visualizer/app/modules/dataset_board/controllers/board_controller.dart';
import 'package:mts_visualizer/app/visualizations/axis.dart';
import 'package:mts_visualizer/app/visualizations/multi_line.dart/multi_line_painter.dart';
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
                                  minV = double.parse(value, (e) => 0);
                                },
                              ),
                              Text("Max"),
                              TextField(
                                onChanged: (value) {
                                  maxV = double.parse(value, (e) => 0);
                                },
                              ),
                              RaisedButton(
                                onPressed: () {
                                  setState(() {});
                                  Get.back();
                                },
                                child: Text("OK"),
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
