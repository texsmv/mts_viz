import 'dart:ui';

import 'package:flutter/material.dart';

class PDialog extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  const PDialog({
    Key? key,
    this.width = 300,
    this.height = 300,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // child: Card(
        //   // color: Colors.red,
        //   color: Colors.white.withOpacity(0.2),
        child: Container(
          // color: Colors.red,
          height: height,
          width: width,
          child: child,
        ),
        // ),
      ),
    );
  }
}
