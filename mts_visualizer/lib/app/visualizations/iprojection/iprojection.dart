import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mts_visualizer/app/visualizations/iprojection/ipoint.dart';
import 'package:mts_visualizer/app/visualizations/iprojection/iprojection_controller.dart';
import 'package:mts_visualizer/app/visualizations/iprojection/iprojection_painter.dart';

class IProjection extends StatefulWidget {
  final List<IPoint> points;
  final List<Color> colors;
  // the index is the id minus 1
  final void Function(List<IPoint> points) onPointsSelected;
  final IProjectionController controller;
  const IProjection({
    Key? key,
    required this.points,
    required this.controller,
    required this.onPointsSelected,
    required this.colors,
  }) : super(key: key);

  @override
  _IProjectionState createState() => _IProjectionState();
}

class _IProjectionState extends State<IProjection>
    with SingleTickerProviderStateMixin {
  IProjectionController get controller => widget.controller;

  @override
  void initState() {
    controller.initAnimation(this);
    controller.points = widget.points;
    controller.onPointsSelected = widget.onPointsSelected;
    controller.initCoordinates();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant IProjection oldWidget) {
    controller.points = widget.points;
    if (oldWidget.points[0].coordinates != widget.points[0].coordinates) {
      controller.initCoordinates();
    } else {
      controller.updateCoordinates();
    }
    // controller.nodes = widget.nodes;
    controller.onPointsSelected = widget.onPointsSelected;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GetBuilder<IProjectionController>(
          id: 'selection',
          tag: controller.boardId,
          builder: (_) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              // color: Colors.blue,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          // color: Colors.red,
                          child: CustomPaint(
                            painter: IProjectionPainter(
                              boardId: controller.boardId,
                              colors: widget.colors,
                            ),
                            willChange: false,
                            isComplex: true,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Listener(
                          behavior: HitTestBehavior.opaque,
                          onPointerDown: controller.onPointerDown,
                          onPointerUp: controller.onPointerUp,
                          onPointerMove: controller.onPointerMove,
                          onPointerHover: controller.onPointerHover,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            // color: Colors.green.withOpacity(0.3),
                          ),
                        ),
                      ),
                      Obx(
                        () => Positioned(
                          left: controller.selectionHorizontalStart,
                          top: controller.selectionVerticalStart,
                          child: Visibility(
                            visible: controller.allowSelection,
                            // visible: true,
                            child: Container(
                              color: Colors.blue.withAlpha(120),
                              width: controller.selectionWidth,
                              height: controller.selectionHeight,
                              // width: 100,
                              // height: 100,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }),
    );
  }
}
