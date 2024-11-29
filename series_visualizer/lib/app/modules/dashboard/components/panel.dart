import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:series_visualizer/app/colors.dart';
import 'package:series_visualizer/app/modules/dashboard/components/mini_panel.dart';
import 'package:series_visualizer/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:series_visualizer/app/widgets/buttons/pButton.dart';
import 'package:series_visualizer/datasets_controller.dart';

class Panel extends GetView<DashboardController> {
  const Panel({Key? key}) : super(key: key);

  DatasetController get datasetsController => Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: double.infinity,
      color: pColorSemiDark,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: GetBuilder<DashboardController>(
              builder: (_) => MiniPanel(),
            ),
          ),
          const SizedBox(height: 20),
          PButton.light(
            text: 'Reload File',
            onTap: () {
              // controller.reloadDatasetsFile();
            },
          ),
          const SizedBox(height: 20),
          PButton(
            text: 'Add Board',
            onTap: () {
              controller.addTab();
            },
          ),
        ],
      ),
    );
  }
}
