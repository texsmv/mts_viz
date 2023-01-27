import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mts_visualizer/app/controllers/datasets_controller.dart';

import 'app/routes/app_pages.dart';

void main() {
  Get.put(DatasetsController());

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
