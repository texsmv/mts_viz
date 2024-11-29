import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:series_visualizer/app/modules/dashboard/components/board.dart';
import 'package:series_visualizer/app/modules/dashboard/controllers/board_controller.dart';
import 'package:series_visualizer/classes/dataset.dart';
import 'package:series_visualizer/datasets_controller.dart';

class TSMeanStdData {
  late List<double> allMean;
  late List<double> allStd;
  List<double>? selectionMean;
  List<double>? selectionStd;
}

class TSMeanStdFetcher extends StatefulWidget {
  final Widget Function(TSMeanStdData data) builder;
  final String datasetId;
  final int dimensionPosition;

  const TSMeanStdFetcher({
    super.key,
    required this.builder,
    required this.datasetId,
    required this.dimensionPosition,
  });

  @override
  State<TSMeanStdFetcher> createState() => TSMeanStdFetcherState();
}

class TSMeanStdFetcherState extends State<TSMeanStdFetcher> {
  DatasetController _controller = Get.find();
  BoardController get _boardController => Get.find(tag: widget.datasetId);
  Dataset get _dataset => _controller.dataset(widget.datasetId);
  List<int> get selectedPositions => _boardController.selectedPositions;
  late TSMeanStdData tsData;
  bool loaded = false;
  @override
  void initState() {
    super.initState();
    _computeData();
  }

  void _computeData() async {
    var data = await _fetchFromPositions(List.generate(_dataset.n, (i) => i));

    tsData = TSMeanStdData();
    tsData.allMean = data['mean']!;
    tsData.allStd = data['std']!;

    loaded = true;
    setState(() {});
  }

  Future<void> _updateData() async {
    if (selectedPositions.isNotEmpty) {
      var selectedData = await _fetchFromPositions(selectedPositions);
      tsData.selectionMean = selectedData['mean'];
      tsData.selectionStd = selectedData['std'];
    }
  }

  Future<Map<String, List<double>>> _fetchFromPositions(List<int> positions) {
    return _controller.apiService
        .getTimeMeanStd(widget.datasetId, widget.dimensionPosition, positions);
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded || tsData == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return GetBuilder<BoardController>(
      id: 'selection',
      tag: widget.datasetId,
      builder: (_) {
        return FutureBuilder(
          future: _updateData(),
          builder: (context, snapshot) {
            return widget.builder(
              tsData,
            );
          },
        );
      },
    );
  }
}
