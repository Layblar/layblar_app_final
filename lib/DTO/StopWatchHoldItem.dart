import 'package:flutter/material.dart';
import 'package:ass/WIdgets/StopwatchItem.dart';

class StopwatchItemsModel extends ChangeNotifier {
  List<StopWatchItem> _stopwatchItems = [];

  List<StopWatchItem> get stopwatchItems => _stopwatchItems;

  void addStopwatchItem(StopWatchItem item) {
    _stopwatchItems.add(item);
    notifyListeners();
  }
  
}