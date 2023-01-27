import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mts_visualizer/app/controllers/datasets_controller.dart';
import 'package:mts_visualizer/app/modules/dashboard/components/board.dart';
import 'package:mts_visualizer/app/modules/dataset_board/controllers/board_controller.dart';
import 'package:mts_visualizer/app/routes/app_pages.dart';
import 'package:mts_visualizer/app/widgets/buttons/pButton.dart';
import 'package:mts_visualizer/app/widgets/containers/pdialog.dart';
import 'package:tabbed_view/tabbed_view.dart';

class DashboardController extends GetxController {
  List<String> get datasets => _datasetsController.names;
  int get nTabs => _tabs.length;

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

  Future<void> loadDataset(String name) async {
    await Get.showOverlay(
      asyncFunction: () async {
        await _datasetsController.loadDataset(name);
        update();
      },
      loadingWidget: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> reloadDatasetsFile() async {
    // await _datasetsController.reloadDatasetsFile();
    // await Get.delete<DatasetsController>();
    // await Get.delete<DashboardController>();
    // Get.put(DatasetsController());
    // Get.put(DashboardController());
    log('-------------------------------RELOADING DATASETS FILE-------------------------');

    _datasetsController.reset();

    await Get.deleteAll(force: true);

    // await Future.delayed(Duration(seconds: 1));

    Get.put(DatasetsController(), permanent: true);

    for (var i = 0; i < _loadedDatasets.length; i++) {
      print('Removing dataset ${_loadedDatasets[i]}');

      // await Get.delete<DashboardController>(
      //     tag: _loadedDatasets[i], force: true);
      // Get.reset<DashboardController>();
      // Get.find();
    }
    Get.offAllNamed(Routes.SPLASH_SCREEN);

    // Get.put(DatasetsController());
    // Get.put(DashboardController());
    // for (var i = 0; i < _loadedDatasets.length; i++) {
    //   await loadDataset(_loadedDatasets[i]);
    //   boardControllers[i].createGrid();
    //   boardControllers[i].initVariables();
    //   boardControllers[i].update();
    // }
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
                datasets.length,
                (index) => PButton.light(
                  text: datasets[index],
                  width: 200,
                  onTap: () async {
                    await Get.showOverlay(asyncFunction: () async {
                      BoardController controller =
                          BoardController(id: datasets[index]);
                      boardControllers.add(controller);
                      Get.put(
                        controller,
                        tag: datasets[index],
                        permanent: true,
                      );
                      tabController.addTab(
                        TabData(
                          text: datasets[index],
                          content: Board(boardId: datasets[index]),
                          keepAlive: true,
                        ),
                      );
                      _loadedDatasets.add(datasets[index]);
                      await loadDataset(datasets[index]);
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

  List<TabData> _tabs = [];
  late TabbedViewController tabController;
  final DatasetsController _datasetsController = Get.find();
  List<BoardController> boardControllers = [];
  List<String> _loadedDatasets = [];
}
