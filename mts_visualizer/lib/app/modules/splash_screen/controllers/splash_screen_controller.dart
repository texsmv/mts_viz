import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:mts_visualizer/api/app_repo.dart';
import 'package:mts_visualizer/api/models/dataset_model.dart';
import 'package:mts_visualizer/app/controllers/datasets_controller.dart';
import 'package:mts_visualizer/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mts_visualizer/app/routes/app_pages.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    // _loadSettings();
    // teste();
    super.onInit();
  }

  Future<void> teste() async {
    DatasetModel dataset = await AppRep.loadDataset('basa_train');
    // print(dataset.array[0]);
  }

  Future<void> loadSettings() async {
    await _datasetsController.init();
    _redirect();
  }

  void _redirect() {
    Get.toNamed(Routes.DASHBOARD);
    // Get.put(DatasetsController());
    // Get.put(DashboardController());
  }

  Future<String?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      String? path = result.files.single.path; 
      if (path != null){
        await AppRep.loadFromPath(path);
      }
      return path;
    }

    return null;
  }

  final DatasetsController _datasetsController = Get.find();
}
