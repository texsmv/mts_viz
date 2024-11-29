import 'package:flutter/material.dart';

class PCard extends StatelessWidget {
  final Widget child;
  const PCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: child,
      ),
    );
  }
}
