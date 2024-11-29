import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:series_visualizer/app/ui_utils.dart';
import 'package:series_visualizer/app/visualizations/iprojection/iprojection_controller.dart';

import 'ipoint.dart';

class IProjectionPainter extends CustomPainter {
  late IProjectionController controller;
  final String boardId;
  final List<Color> colors;
  IProjectionPainter({
    required this.boardId,
    required this.colors,
  }) {
    controller = Get.find(tag: boardId);
  }

  late Canvas _canvas;
  late double _width;
  late double _height;
  // Paint selectedPaint = Paint()
  //   ..color = Colors.black
  //   ..style = PaintingStyle.fill;
  Paint nodePaint = Paint()
    ..color = Color.fromRGBO(120, 120, 120, 1)
    ..style = PaintingStyle.fill;
  Paint normalFillPaint = Paint()
    ..color = Color.fromRGBO(190, 190, 190, 1)
    ..style = PaintingStyle.fill;
  Paint normalBorderPaint = Paint()
    ..color = Color.fromRGBO(170, 170, 170, 1)
    ..style = PaintingStyle.stroke;
  Paint selectedBorderPaint = Paint()
    // ..color = Color.fromRGBO(220, 10, 10, 1)
    ..color = Colors.black
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    // print("painting");
    _canvas = canvas;
    _height = size.height;
    _width = size.width;
    for (int i = 0; i < controller.points.length; i++) {
      if (!controller.points[i].selected) {
        plotPoint(controller.points[i], i);
      }
    }
    for (int i = 0; i < controller.points.length; i++) {
      if (controller.points[i].selected) {
        plotPoint(controller.points[i], i);
      }
    }
  }

  void plotPoint(IPoint point, int position) {
    late Paint fillPaint;
    Paint borderPaint;
    if (point.cluster != null) {
      fillPaint = Paint()
        // ..color = uiClusterColor(point.cluster!).withOpacity(0.4)
        ..color = Colors.red
        ..style = PaintingStyle.fill;
    } else {
      fillPaint = fillPaint = Paint()
        // ..color = uiClusterColor(point.cluster!).withOpacity(0.4)
        ..color = colors[position].withOpacity(point.selected ? 1 : 0.6)
        ..style = PaintingStyle.fill;
    }
    borderPaint = normalBorderPaint;
    if (point.selected) {
      borderPaint = selectedBorderPaint;
      // fillPaint.color = Color.fromRGBO(0, 50, 120, 0.8);
    } else {
      // fillPaint.color = Color.fromRGBO(120, 120, 120, 0.8);
    }

    // if (point.canvasCoordinates == null) {
    //   point.computeCanvasCoordinates(_width, _height);
    // }
    Offset canvasCoordinates = computeCanvasCoordinates(
        controller.currentCoordinates[position].dx,
        controller.currentCoordinates[position].dy,
        _width,
        _height);

    point.canvasCoordinates = canvasCoordinates;

    double radius = 4;
    if (point.selected) {
      radius = 8;
    }
    if (point.isHighlighted) {
      radius = 12;
    }
    _canvas.drawCircle(
      point.canvasCoordinates,
      radius,
      fillPaint,
    );
    if (point.selected) {
      _canvas.drawCircle(
        point.canvasCoordinates,
        radius,
        borderPaint,
      );
    }
  }

  Offset computeCanvasCoordinates(
      double dx, double dy, double width, double height) {
    final double x =
        uiRangeConverter(dx, controller.minX, controller.maxX, 0, width);
    final double y = height -
        uiRangeConverter(dy, controller.minY, controller.maxY, 0, height);
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
    return controller.shouldRepaint;
  }
}
