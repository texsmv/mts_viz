import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:menu_button/menu_button.dart';
import 'package:mts_visualizer/app/controllers/datasets_controller.dart';
import 'package:mts_visualizer/app/extensions/colors.dart';
import 'package:mts_visualizer/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mts_visualizer/app/modules/dataset_board/controllers/board_controller.dart';
import 'package:mts_visualizer/app/widgets/buttons/pButton.dart';

class MiniPanel extends GetView<DashboardController> {
  const MiniPanel({Key? key}) : super(key: key);

  DatasetsController get datasetsController => Get.find();
  @override
  Widget build(BuildContext context) {
    if (controller.tabController.selectedIndex == null) {
      return const Center(
        child: Text(
          'No boards added',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }

    BoardController boardController =
        controller.boardControllers[controller.tabController.selectedIndex!];
    return Container(
      width: 250,
      height: double.infinity,
      color: pColorSemiDark,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Status: ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(width: 10),
                datasetsController.isDatasetLoaded(boardController.id)
                    ? const Text(
                        "Loaded",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 17,
                        ),
                      )
                    : const Text(
                        "Not Loaded",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                        ),
                      ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    await controller.loadDataset(boardController.id);
                    controller.boardControllers[
                            controller.tabController.selectedIndex!]
                        .initVariables();
                    controller.boardControllers[
                            controller.tabController.selectedIndex!]
                        .update();
                  },
                  child: Container(
                    height: 20,
                    width: 20,
                    color: pColorGray,
                    child: const Icon(
                      Icons.replay_outlined,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            settings(),
          ],
        ),
      ),
    );
  }

  Widget settings() {
    BoardController boardController =
        controller.boardControllers[controller.tabController.selectedIndex!];
    if (boardController.dataset == null) return const SizedBox();
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: boardController.dataset!.dimensions.length,
          itemBuilder: (context, index) => Container(
            height: 30,
            child: Row(
              children: [
                Text(
                  boardController.dataset!.dimensions[index],
                  style: const TextStyle(color: Colors.white),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    boardController.addChart(index);
                  },
                  icon: const Icon(
                    Icons.add,
                    color: pColorSecondary,
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        boardController.labelsEnable
            ? Column(
                children: [
                  const Text('Labels'),
                  MenuButton<String>(
                    items: boardController.dataset!.labelsOptions!,
                    itemBuilder: (String value) => Container(
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
                      // setState(() {
                      //   selectedKey = value;
                      // });
                      boardController.dataset!.slabel = value;
                      boardController.updateLabelOption();
                    },
                    onMenuButtonToggle: (bool isToggle) {
                      print(isToggle);
                    },
                    child: Container(
                      width: 150,
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      child: Text(boardController.dataset!.slabel!),
                    ),
                  )
                ],
              )
            : const SizedBox()
      ],
    );
  }
}
