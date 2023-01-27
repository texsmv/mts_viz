import 'package:get/state_manager.dart';
import 'package:mts_visualizer/api/app_repo.dart';
import 'package:mts_visualizer/api/models/dataset_model.dart';

class DatasetsController extends GetxController {
  List<String> get names => _names;
  DatasetModel? dataset(String name) {
    return _datasets[name];
  }

  Future<void> init() async {
    _names = await AppRep.datasetsNames();
  }

  Future<void> reloadDatasetsFile() async {
    _datasets = {};
    await AppRep.reloadFile();
  }

  Future<void> loadDataset(String name) async {
    DatasetModel dataset = await AppRep.loadDataset(name);
    _datasets[name] = dataset;
  }

  void reset() {
    _datasets = {};
    _names = [];
  }

  bool isDatasetLoaded(String name) => _datasets.containsKey(name);

  List<String> _names = [];
  Map<String, DatasetModel> _datasets = {};
}
