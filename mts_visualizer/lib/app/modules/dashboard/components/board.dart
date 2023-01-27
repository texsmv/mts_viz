import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_button/menu_button.dart';
import 'package:mts_visualizer/app/modules/dataset_board/controllers/board_controller.dart';
import 'package:mts_visualizer/app/visualizations/iprojection/iprojection.dart';
import 'package:mts_visualizer/app/widgets/containers/pcard.dart';

class Board extends StatelessWidget {
  final String boardId;
  const Board({Key? key, required this.boardId}) : super(key: key);

  BoardController get controller => Get.find<BoardController>(tag: boardId);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoardController>(
      tag: boardId,
      builder: (_) => Row(
        children: [
          Expanded(
            flex: 7,
            child: Row(
              children: List.generate(
                controller.nrows,
                (i) => Expanded(
                  child: Column(
                    children: List.generate(
                      controller.ncols,
                      (j) => Expanded(child: controller.grid[i][j]),
                    ),
                  ),
                ),
              ),
            ),
          ),
          controller.coordsEnable
              ? Expanded(
                  flex: 2,
                  child: controller.dataset != null
                      ? Container(
                          width: 500,
                          height: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              controller.labelsEnable
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Projection'),
                                        MenuButton<String>(
                                          items: controller
                                              .dataset!.coordsOptions!,
                                          itemBuilder: (String value) =>
                                              Container(
                                            height: 30,
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0.0, horizontal: 16),
                                            child: Text(value),
                                          ),
                                          toggledChild: Container(
                                            child: SizedBox(),
                                          ),
                                          onItemSelected: (String value) {
                                            // boardController.dataset!.slabel =
                                            //     value;
                                            // boardController
                                            //     .updateLabelOption();
                                            controller
                                                .updateCoordsOption(value);
                                          },
                                          onMenuButtonToggle:
                                              (bool isToggle) {},
                                          child: Container(
                                            width: 150,
                                            height: 30,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                controller.dataset!.scoord!),
                                          ),
                                        )
                                      ],
                                    )
                                  : const SizedBox(),
                              AspectRatio(
                                aspectRatio: 1,
                                child: PCard(
                                  child: GetBuilder<BoardController>(
                                    tag: boardId,
                                    builder: (_) => IProjection(
                                      points: controller.ipoints!,
                                      onPointsSelected: (points) {
                                        controller.onPointsSelected(points);
                                      },
                                      colors: controller.pointColors,
                                      controller:
                                          controller.projectionController,
                                    ),
                                  ),
                                ),
                                // child: ,
                              ),
                              Expanded(
                                child: controller.labelsEnable
                                    ? ListView.builder(
                                        // shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                            height: 30,
                                            child: ListTile(
                                              title: Text(
                                                controller
                                                    .clusterLabelsNames[index]
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: controller
                                                          .clusterColors[
                                                      controller.clusterLabels![
                                                          index]],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onTap: () {
                                                controller.selectDimension(
                                                    controller
                                                        .clusterLabels![index]);
                                              },
                                            ),
                                          );
                                        },
                                        itemCount:
                                            controller.clusterLabels!.length,
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
