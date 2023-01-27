import 'package:mts_visualizer/app/extensions/list_shape_extension.dart';
import 'package:scidart/numdart.dart';

class DatasetModel {
  // NxDxT format
  final List<dynamic> dataList;

  late Array3d array;

  final List<String> dimensions;

  // Dict of Nx2 format
  Map<String, List<dynamic>>? coordsMap;

  Map<String, Map<int, String>>? labelsNames;

  // Nx1 format
  Map<String, List<int>>? pointLabels;

  int get n => array.shape[0];
  int get t => array.shape[2];
  int get d => array.shape[1];

  // selected coords
  String? scoord;

  // selected labels
  String? slabel;

  List<dynamic>? get coords => coordsMap != null ? coordsMap![scoord!] : null;

  bool get hasCoords => coords != null;

  bool get hasLabels => slabel != null;

  Map<int, String>? get labelsMap =>
      labelsNames != null ? labelsNames![slabel!] : null;

  List<int>? get labels => pointLabels != null ? pointLabels![slabel!] : null;

  List<String>? get labelsOptions =>
      pointLabels != null ? pointLabels!.keys.toList() : null;

  List<String>? get coordsOptions =>
      coordsMap != null ? coordsMap!.keys.toList() : null;

  DatasetModel({
    required this.dataList,
    required this.dimensions,
    this.labelsNames,
    this.coordsMap,
    this.pointLabels,
  }) {
    array = Array3d(
      List.generate(
        dataList.shape[0],
        (int index) {
          List<dynamic> d = dataList[index];
          d = d.flatten();
          Array2d arr = Array2d.fromVector(
              Array(List<double>.from(d)), dataList.shape[2]);
          return arr;
          // print(index);
          // return matrixTranspose(arr);
        },
      ),
    );

    if (pointLabels != null) {
      slabel = pointLabels!.keys.first;
    }

    if (coordsMap != null) {
      scoord = coordsMap!.keys.first;
    }
  }

  Array2d getDimension(int index) {
    Array2d dMatrix = Array2d.fixed(n, t);
    for (int i = 0; i < n; i++) {
      // print(array[i][index].length);
      // print(t);
      for (int j = 0; j < t; j++) {
        dMatrix[i][j] = array[i][index][j];
        // array[i][index];
        // array[i][index][j];
      }
    }
    return dMatrix;
  }
}
