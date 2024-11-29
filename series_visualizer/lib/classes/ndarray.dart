import 'dart:math';

class NDArray {
  List<dynamic> data;
  late List<int> shape;
  int get length => shape.first;

  NDArray(this.data) {
    shape = _inferShape(data);
  }

  // Infers the shape of the data recursively.
  List<int> _inferShape(dynamic array) {
    if (array is List) {
      if (array.isEmpty) return [0];
      List<int> subShape = _inferShape(array.first);
      return [array.length, ...subShape];
    }
    return [];
  }

  // Flattens the tensor into a 1D list.
  List<dynamic> _flatten(dynamic array) {
    if (array is! List) return [array];
    return array.expand((element) => _flatten(element)).toList();
  }

  // Reshapes the tensor to a new shape.
  void reshape(List<int> newShape) {
    int totalSize = shape.reduce((a, b) => a * b);
    int newSize = newShape.reduce((a, b) => a * b);

    if (totalSize != newSize) {
      throw ArgumentError(
          "Cannot reshape array of size $totalSize to $newShape");
    }

    List<dynamic> flatData = _flatten(data);
    data = _buildFromFlat(flatData, newShape);
    shape = newShape;
  }

  // Rebuilds the tensor from a flat list given the new shape.
  List<dynamic> _buildFromFlat(List<dynamic> flatData, List<int> targetShape) {
    if (targetShape.length == 1) {
      return flatData.sublist(0, targetShape[0]);
    }

    int size = targetShape.first;
    int subSize = flatData.length ~/ size;
    List<dynamic> result = [];

    for (int i = 0; i < size; i++) {
      result.add(_buildFromFlat(
          flatData.sublist(i * subSize, (i + 1) * subSize),
          targetShape.sublist(1)));
    }
    return result;
  }

  @override
  String toString() {
    return 'NDArray(shape: $shape, data: $data)';
  }
}

// void main() {
//   // Example: Creating a tensor and reshaping it
//   var array = NDArray([
//     [1, 2, 3],
//     [4, 5, 6],
//   ]);

//   print(array); // NDArray(shape: [2, 3], data: [[1, 2, 3], [4, 5, 6]])

//   array.reshape([3, 2]);
//   print(array); // NDArray(shape: [3, 2], data: [[1, 2], [3, 4], [5, 6]])

//   array.reshape([6]);
//   print(array); // NDArray(shape: [6], data: [1, 2, 3, 4, 5, 6])

//   array.reshape([2, 1, 3]);
//   print(array); // NDArray(shape: [2, 1, 3], data: [[[1, 2, 3]], [[4, 5, 6]]])
// }
