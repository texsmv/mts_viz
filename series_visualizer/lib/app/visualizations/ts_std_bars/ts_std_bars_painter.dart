import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:series_visualizer/app/ui_utils.dart';

class StdChartPainter extends CustomPainter {
  List<double> means;
  List<double> stds;
  double minV;
  double maxV;
  Color color;

  StdChartPainter({
    required this.means,
    required this.stds,
    required this.minV,
    required this.maxV,
    required this.color,
  });
  late int _n;
  late double _width;
  late double _height;
  late double _horizontalSpace;
  late Canvas _canvas;
  final int nStds = 3;

  @override
  void paint(Canvas canvas, Size size) {
    _n = means.length;
    _width = size.width;
    _height = size.height;
    _horizontalSpace = _width / (_n - 1);
    _canvas = canvas;
    drawMean();

    drawStd();
  }

  void drawMean() {
    Path path = Path();
    path.moveTo(0, value2Heigh(means[0]));
    for (var i = 1; i < _n; i++) {
      path.lineTo(
        i * _horizontalSpace,
        value2Heigh(means[i]),
      );
    }
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    _canvas.drawPath(
      path,
      paint,
    );
  }

  void drawStd() {
    Path path = Path();

    path.moveTo(0, value2Heigh(means[0] + stds[0] * nStds));
    for (var i = 1; i < _n; i++) {
      path.lineTo(
        i * _horizontalSpace,
        value2Heigh(means[i] + stds[i] * nStds),
      );
    }

    path.lineTo(_width, value2Heigh(means[_n - 1] - stds[_n - 1] * nStds));

    for (var i = _n - 1; i > -1; i--) {
      path.lineTo(
        i * _horizontalSpace,
        value2Heigh(means[i] - stds[i] * nStds),
      );
    }
    path.lineTo(0, value2Heigh(means[0] + stds[0] * nStds));

    Paint paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.5;
    _canvas.drawPath(
      path,
      paint,
    );
  }

  double value2Heigh(double value) {
    if (value > maxV || value < minV) {
      print('Value out of range: $value');
    }
    return _height - uiRangeConverter(value, minV, maxV, 0, _height);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
