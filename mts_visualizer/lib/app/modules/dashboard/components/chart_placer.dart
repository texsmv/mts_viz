import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mts_visualizer/app/modules/dataset_board/controllers/board_controller.dart';
import 'package:mts_visualizer/app/widgets/containers/pcard.dart';

class ChartPlacer extends StatelessWidget {
  final String boardId;
  final int row;
  final int col;
  Widget? child;
  ChartPlacer({
    Key? key,
    required this.boardId,
    required this.row,
    required this.col,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoardController boardController = Get.find(tag: boardId);
    return GetBuilder<BoardController>(
      tag: boardId,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(10),
        child: PCard(
          child: GestureDetector(
            onTap: () {
              boardController.sCol = col;
              boardController.sRow = row;
              boardController.update();
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      boardController.sCol == col && boardController.sRow == row
                          ? Colors.blue
                          : Colors.transparent,
                  width: 2,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
