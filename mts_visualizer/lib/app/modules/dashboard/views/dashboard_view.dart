import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mts_visualizer/app/modules/dashboard/components/panel.dart';
import 'package:mts_visualizer/app/widgets/buttons/pButton.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Panel(),
          Expanded(
            child: GetBuilder<DashboardController>(
              builder: (_) => controller.nTabs == 0
                  ? Center(
                      child: PButton(
                        text: 'Add Board',
                        onTap: () {
                          controller.addTab();
                        },
                      ),
                    )
                  : TabbedView(
                      controller: controller.tabController,
                      closeButtonTooltip: 'Click here to close the tab',
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
