import "dart:async";
import "package:ass/DTO/Device/DeviceDTO.dart";
import "package:ass/DTO/StopWatchHoldItem.dart";
import "package:flutter/material.dart";
import "package:ass/Themes/Styles.dart";
import "package:ass/Themes/ThemeColors.dart";
import "package:ass/WIdgets/BlinkingDot.dart";
import "package:http/http.dart";
import "package:provider/provider.dart";

// ignore: must_be_immutable
class StopWatchItem extends StatefulWidget {
   StopWatchItem({
    required this.selectedDevice,
    required this.stopwatch,
    this.isPaused = false,
    this.result = '00:00:00',
    required this.onStopWatchItemDeleted,
    Key? key,
  }) : super(key: key);

  final DeviceDTO selectedDevice;
  final Stopwatch stopwatch;
  bool isPaused;
  String result;
  Function onStopWatchItemDeleted;

  @override
  State<StopWatchItem> createState() => _StopWatchItemState();
}

class _StopWatchItemState extends State<StopWatchItem> {
  late Timer _timer;
  bool _isRunning = false;
  late DateTime startTime;
  late DateTime endTime;

  @override
  void initState() {
    super.initState();
    if (!widget.isPaused) {
      _start();
    }
    startTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: Styles.containerDecoration,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(widget.selectedDevice.deviceName, style: Styles.regularTextStyle,),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BlinkingDotWidget(isRunning: _isRunning),
                Container(
                  decoration: Styles.primaryBackgroundContainerDecoration,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(widget.result),
                  ),
                ),
                _isRunning?
                ElevatedButton(
                    style: Styles.errorButtonStyle,
                    onPressed: (){
                      _stop();
                      widget.isPaused = true; 
                    },
                    child:  Icon(Icons.stop, color: ThemeColors.secondaryBackground,),
                )
                :const SizedBox(),
                IconButton(onPressed: () => _delete(), icon: Icon(Icons.delete, color: ThemeColors.textColor)),
                IconButton(onPressed: () {}, icon: Icon(Icons.send, color: ThemeColors.textColor)),

              ],
            ),
          ],
        ),
      ),
    );
  }

  void _start() {
        var stopwatchItemsModel = Provider.of<StopwatchItemsModel>(context, listen: false);
    debugPrint("[---STOPWATCHES]" + stopwatchItemsModel.stopwatchItems.length.toString());

    if (mounted) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
        if (mounted) {
          setState(() {
            widget.result = '${widget.stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(widget.stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(widget.stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
          });
        } else {
          t.cancel();
        }
      });
      widget.stopwatch.start();

    }
  }

  void _stop() {
    _timer.cancel();
    widget.stopwatch.stop();
    setState(() {
      _isRunning = false;
      endTime = DateTime.now();

      debugPrint("[---start]" + startTime.toString());
      debugPrint("[---end]" + endTime.toString());

    });
  }


  void _submit(String household, String time) {
    debugPrint("submitted: " + household + ", " + time);
  }

  void _delete() {
    var stopwatchItemsModel = Provider.of<StopwatchItemsModel>(context, listen: false);

      stopwatchItemsModel.removeStopwatchItem(widget);
      debugPrint("[---STOPWATCHES]" + stopwatchItemsModel.stopwatchItems.length.toString());
            widget.onStopWatchItemDeleted();



  }
    

  @override
  void dispose() {
    super.dispose();
  }
}
