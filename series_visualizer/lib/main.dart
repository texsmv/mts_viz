import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:series_visualizer/datasets_controller.dart';

import 'app/routes/app_pages.dart';

void main() {
  Get.put(DatasetController(), permanent: true);
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
