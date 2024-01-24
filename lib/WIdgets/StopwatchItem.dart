import "dart:async";
import "package:ass/API/APIController.dart";
import "package:ass/DTO/Device/DeviceDTO.dart";
import "package:ass/DTO/SmartMeter/SmartMeterDataDTO.dart";
import 'package:ass/HelperClasses/StopWatchHoldItem.dart';
import "package:ass/HelperClasses/StatusCodes.dart";
import "package:ass/WIdgets/BottomToast.dart";
import "package:flutter/material.dart";
import "package:ass/Themes/Styles.dart";
import "package:ass/Themes/ThemeColors.dart";
import "package:ass/WIdgets/BlinkingDot.dart";
import "package:jwt_decoder/jwt_decoder.dart";
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
                :ElevatedButton(style: Styles.secondaryButtonStyle, onPressed: () => addLabeledData(widget.selectedDevice, startTime, endTime), child: Icon(Icons.send, color: ThemeColors.secondaryBackground)),
                IconButton(onPressed: () => _delete(), icon: Icon(Icons.delete, color: ThemeColors.textColor)),
          
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


  Future<void> addLabeledData(DeviceDTO deviceDTO, DateTime start, DateTime end) async{
      String? token = await APIController.getTokenFromSharedPreferences();


    if(token != null){
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        if(JwtDecoder.isExpired(token)){
          //add context
        }else{

           
            //transforming the datetime into unix
            var startTime = start.millisecondsSinceEpoch;
            var endTime = end.microsecondsSinceEpoch;
            // Unix-Timestamp als String
            String startTimestamp = (startTime / 1000).toString();
            String endTimestamp = (endTime / 1000).toString();

            var startParts = startTimestamp.split('.');
            String from = startParts[0];

            var endParts = endTimestamp.split('.');
            String to = endParts[0];

           

            String householdId = decodedToken['householdId'];
            List<SmartMeterDataDTO> smartMeterData = await APIController.getSmartMeterData(token, householdId, from, to);

            int response = await APIController.addLabeledData(token, householdId, deviceDTO, smartMeterData);

            if(response == StatusCodes.CREATED){
              _delete();
              BottomToast.showToast("New Label successfully added!");
            }else if(response == StatusCodes.UNAUTHORIZED){
              BottomToast.showToast("STH STRANGE HAPPENED: $response");
            }else if(response == StatusCodes.INVALID_USER){
              BottomToast.showToast("STH STRANGE HAPPENED: $response");
            }else if(response == StatusCodes.SERVER_ERROR){
              BottomToast.showToast("STH STRANGE HAPPENED: $response");
            }else{
              BottomToast.showToast("STH STRANGE HAPPENED: $response");
            }
        }
    }

  }
}
