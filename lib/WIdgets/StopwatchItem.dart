import "dart:async";
import "package:flutter/material.dart";
import "package:ass/Themes/Styles.dart";
import "package:ass/Themes/ThemeColors.dart";
import "package:ass/WIdgets/BlinkingDot.dart";

// ignore: must_be_immutable
class StopWatchItem extends StatefulWidget {
   StopWatchItem({
    required this.selectedDevice,
    required this.stopwatch,
    this.isPaused = false,
    this.result = '00:00:00',
    Key? key,
  }) : super(key: key);

  final String selectedDevice;
  final Stopwatch stopwatch;
  bool isPaused;
  String result;


  @override
  State<StopWatchItem> createState() => _StopWatchItemState();
}

class _StopWatchItemState extends State<StopWatchItem> {
  late Timer _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    if (!widget.isPaused) {
      _start();
    }
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
              child: Text(widget.selectedDevice, style: Styles.regularTextStyle,),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlinkingDotWidget(isRunning: _isRunning),
                Container(
                  decoration: Styles.primaryBackgroundContainerDecoration,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(widget.result),
                  ),
                ),
                _isRunning
                    ? ElevatedButton(
                        style: Styles.errorButtonStyle,
                        onPressed: (){
                          _stop();
                          widget.isPaused = true;
                        },
                        child:  Icon(Icons.pause, color: ThemeColors.secondaryBackground,),
                      )
                    : ElevatedButton(
                        style: Styles.primaryButtonStyle,
                        onPressed:(){
                          _start();
                          widget.isPaused = false;
                        },
                        child:
                            Icon(Icons.play_arrow, color: ThemeColors.secondaryBackground,),),
                ElevatedButton(
                    style: Styles.secondaryButtonStyle,
                    onPressed: _reset,
                    child: Text("Reset", style: Styles.secondaryTextStyle)),
                IconButton(onPressed: () {}, icon: Icon(Icons.delete, color: ThemeColors.textColor)),
                IconButton(onPressed: () {}, icon: Icon(Icons.send, color: ThemeColors.textColor)),

              ],
            ),
          ],
        ),
      ),
    );
  }

  void _start() {
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
    });
  }

  void _reset() {
    _stop();
    widget.stopwatch.reset();    
    setState(() {
      _isRunning = false;
      widget.result = '00:00:00';
    });

  }

  void _submit(String household, String time) {
    debugPrint("submitted: " + household + ", " + time);
  }

  void _delete() {
    dispose();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
