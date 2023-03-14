import 'dart:convert';

import 'package:http/http.dart';
import 'package:mts_visualizer/api/models/dataset_model.dart';
import 'package:mts_visualizer/app/extensions/list_shape_extension.dart';

class AppRep {
  // static String hostUrl = 'http://192.168.122.1:8000/';
  static String hostUrl = 'http://127.0.0.1:5000';

  static Future<List<String>> datasetsNames() async {
    final response = await post(Uri.parse('$hostUrl/objectsInfo'));
    dynamic data = jsonDecode(response.body);
    return List<String>.from(data['names']);
  }

  static Future<void> reloadFile() async {
    final response = await post(Uri.parse('$hostUrl/loadFile'));
    dynamic data = jsonDecode(response.body);
    return;
  }

  static Future<DatasetModel> loadDataset(String name) async {
    final response = await post(
      Uri.parse('$hostUrl/object'),
      body: jsonEncode({'name': name}),
      headers: {"Content-Type": "application/json"},
    );
    dynamic data = jsonDecode(response.body);

    List<dynamic> mts = data['data'];
    List<int> shape = List<int>.from(data['shape']);
    mts = mts.reshape(shape);

    // * Reading coords
    Map<String, List<dynamic>>? coordsMap;

    if (data.containsKey('coords')) {
      coordsMap = {};
      Map<String, dynamic> tempMap = Map<String, dynamic>.from(data['coords']);
      tempMap.forEach((key, value) {
        List<dynamic> dcoords = value;
        List<dynamic>? coords;
        coords = dcoords.reshape([shape[0], 2]);
        coordsMap![key] = coords;
      });
    }

    //  Reading labels
    Map<String, List<int>>? pointLabels;

    if (data.containsKey('labels')) {
      pointLabels = {};
      Map<String, dynamic> tempMap = Map<String, dynamic>.from(data['labels']);

      tempMap.forEach((key, value) {
        List<dynamic> dlabels = value;
        List<int> labels =
            List.generate(dlabels.length, (index) => dlabels[index]);
        pointLabels![key] = labels;
      });
    }

    // Read labels names
    Map<String, Map<int, String>>? labelsNames;

    if (data.containsKey('labelsNames')) {
      print("----------------------------------");
      print("--------------- labels found---------------");
      print("----------------------------------");
      labelsNames = {};
      Map<String, dynamic> tempMap =
          Map<String, dynamic>.from(data['labelsNames']);

      tempMap.forEach((key, value) {
        Map<String, String> temp = Map<String, String>.from(value);
        Map<int, String> labelsMap = {};
        temp.forEach((k, v) {
          print(k);
          labelsMap[(int.parse(k))] = v;
        });
        labelsNames![key] = labelsMap;
      });
      print(labelsNames);
    } else {
      print("----------------------------------");
      print("-------------No labels found---------------");
      print("----------------------------------");
    }

    List<String> dimensions = List<String>.from(data['dimensions']);
    return DatasetModel(
      dataList: mts,
      labelsNames: labelsNames,
      coordsMap: coordsMap,
      dimensions: dimensions,
      pointLabels: pointLabels,
    );
  }
}
