import 'package:collection/collection.dart';

class ChartItem {
  final double x;
  final double y;

  ChartItem({required this.x, required this.y});
}

List<ChartItem> get chartItems {
  final data = <double> [2,5,2,6,8,4,6,9,1,4];
  return data.mapIndexed(
    ((index, element) =>  ChartItem(x: index.toDouble(), y: element.toDouble())))
    .toList();
}