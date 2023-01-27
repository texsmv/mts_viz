import 'package:flutter/material.dart';
import 'package:mts_visualizer/app/extensions/colors.dart';
import 'package:nice_buttons/nice_buttons.dart';

class PButton extends StatelessWidget {
  final String text;
  final Function onTap;

  late Color fillColor;
  late Color textColor;

  final double width;
  final double height;

  PButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.fillColor = pColorSecondary,
    this.textColor = Colors.white,
    this.width = 120,
    this.height = 40,
  }) : super(key: key);

  PButton.light({
    Key? key,
    required this.text,
    required this.onTap,
    this.width = 120,
    this.height = 40,
  }) : super(key: key) {
    fillColor = pColorSecondary;
    textColor = Colors.white;
  }
  PButton.dark({
    Key? key,
    required this.text,
    required this.onTap,
    this.width = 120,
    this.height = 40,
  }) : super(key: key) {
    fillColor = pColorSemiDark;
    textColor = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: NiceButtons(
        stretch: true,
        width: width,
        height: height,
        gradientOrientation: GradientOrientation.Horizontal,
        startColor: fillColor,
        endColor: fillColor,
        borderColor: fillColor.withOpacity(0.5),
        onTap: (finish) {
          onTap();
        },
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
