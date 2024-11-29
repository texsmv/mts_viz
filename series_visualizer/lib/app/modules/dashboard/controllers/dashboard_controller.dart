import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:series_visualizer/app/modules/dashboard/components/board.dart';
import 'package:series_visualizer/app/modules/dashboard/controllers/board_controller.dart';
import 'package:series_visualizer/app/widgets/buttons/pButton.dart';
import 'package:series_visualizer/app/widgets/containers/pdialog.dart';
import 'package:series_visualizer/datasets_controller.dart';
import 'package:tabbed_view/tabbed_view.dart';

class DashboardController extends GetxController {
  final DatasetController _controller = Get.find();
  late TabbedViewController tabController;
  int get nTabs => _tabs.length;
  List<TabData> _tabs = [];
  List<BoardController> boardControllers = [];

  @override
  void onInit() {
    initTabs();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void initTabs() {
    tabController = TabbedViewController(_tabs);
    tabController.addListener(() {
      update();
    });
  }

  void addTab() {
    Get.dialog(
      PDialog(
        height: 600,
        width: 500,
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _controller.availableDatasets.length,
                (index) => PButton.light(
                  text: _controller.availableDatasets[index],
                  width: 200,
                  onTap: () async {
                    await Get.showOverlay(asyncFunction: () async {
                      String datasetName = _controller.availableDatasets[index];
                      await _controller.loadDataset(datasetName);

                      BoardController controller = BoardController(
                          id: datasetName,
                          dataset: _controller.dataset(datasetName));
                      boardControllers.add(controller);
                      Get.put(
                        controller,
                        tag: datasetName,
                        permanent: true,
                      );
                      tabController.addTab(
                        TabData(
                          text: datasetName,
                          content: Board(datasetId: datasetName),
                          keepAlive: true,
                        ),
                      );

                      controller.initVariables();
                      controller.update();
                    });
                    Get.back();
                    update();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // tabController.addTab(TabData(text: '$millisecond'));
  }
}
