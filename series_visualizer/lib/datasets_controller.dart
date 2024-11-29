import 'package:get/get.dart';
import 'package:series_visualizer/classes/dataset.dart';
import 'package:series_visualizer/repository.dart';

class DatasetController extends GetxController {
  static String hostUrl = 'http://127.0.0.1:8000';
  ApiService apiService = ApiService(hostUrl);

  Future<void> loadDatasetsInfo() async {
    availableDatasets = await apiService.getObjectNames();
  }

  Future<void> loadDataset(String datasetName) async {
    final data = await apiService.getObjectInfo(datasetName);
    Dataset dataset = Dataset.fromJson(data);
    datasets[datasetName] = dataset;
  }

  Dataset dataset(String id) {
    return datasets[id]!;
  }

  bool isDatasetLoaded(String name) => datasets.containsKey(name);

  

  late List<String> availableDatasets;
  List<String> get loadedDatasets => datasets.keys.toList();
  Map<String, Dataset> datasets = {};
}
