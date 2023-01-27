import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

double uiRangeConverter(double oldValue, double oldMin, double oldMax,
    double newMin, double newMax) {
  return (((oldValue - oldMin) * (newMax - newMin)) / (oldMax - oldMin)) +
      newMin;
}

Future<void> uiDelayed(VoidCallback callback,
    {Duration delay = const Duration(milliseconds: 250)}) async {
  await Future.delayed(delay);
  callback();
}

double uiEuclideanDistance(List<double> vectorA, List<double> vectorB) {
  assert(vectorA.length == vectorB.length);
  double distance = 0.0;
  for (int i = 0; i < vectorA.length; i++) {
    distance += pow(vectorA[i] - vectorB[i], 2);
  }
  return sqrt(distance);
}

List<Color> colorList = [
  const Color.fromRGBO(2, 62, 138, 1),
  const Color.fromRGBO(251, 133, 0, 1),
  const Color.fromRGBO(255, 0, 109, 1),
  const Color.fromRGBO(2, 48, 71, 1),
  const Color.fromRGBO(33, 158, 188, 1),
  const Color.fromRGBO(45, 106, 79, 1),
  const Color.fromRGBO(214, 40, 40, 1),
  const Color.fromRGBO(112, 224, 0, 1),
  const Color.fromRGBO(255, 183, 3, 1),
  const Color.fromRGBO(131, 56, 236, 1),
  const Color.fromRGBO(119, 73, 54, 1),
];

Color uiGetColor(int index) {
  if (index < colorList.length) {
    return colorList[index];
  }
  RandomColor _randomColor = RandomColor();
  return _randomColor.randomColor();
}

List<Color> uiRangeColor(int length) {
  return List.generate(length,
      (index) => Color.fromRGBO(0, 0, ((255 / length) * index).toInt(), 1));
}

extension ColorExtension on Color {
  Color addBrightness(int val) {
    int nred = (min(max(red + val, 0), 255)).toInt();
    int ngreen = (min(max(green + val, 0), 255)).toInt();
    int nblue = (min(max(blue + val, 0), 255)).toInt();
    return Color.fromRGBO(
      nred,
      ngreen,
      nblue,
      opacity,
    );
  }
}
