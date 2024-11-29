import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:series_visualizer/app/routes/app_pages.dart';
import 'package:series_visualizer/datasets_controller.dart';

class SplashController extends GetxController {
  void loadObjectsFile() async {
    String? path = await pickFile();
    if (path != null) {
      await datasetController.apiService.loadFromPath(path);
      await datasetController.loadDatasetsInfo();
    }

    Get.toNamed(Routes.DASHBOARD);
  }

  DatasetController datasetController = Get.find();

  Future<String?> pickFile() async {
    return "/home/texs/Documents/PersonalProjects/mts_viz/server/mts_datasets.npy";
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      String? path = result.files.single.path;
      return path;
    }

    return null;
  }
}
