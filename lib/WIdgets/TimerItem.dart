import 'package:flutter/material.dart';
import 'package:ass/Themes/Styles.dart';
import 'package:ass/Themes/ThemeColors.dart';
import 'package:ass/WIdgets/BlinkingDot.dart';
import 'dart:async';

// ignore: must_be_immutable
class TimerItem extends StatefulWidget {
    TimerItem({
    required this.selectedDevice,
    required this.hours,
    required this.minutes,
    required this.seconds,
    this.isPaused = false,
    Key? key}) : super(key: key);


  final String selectedDevice;
   int hours;
   int minutes;
   int seconds;
  bool isPaused;

  @override
  State<TimerItem> createState() => _TimerItemState();
}

class _TimerItemState extends State<TimerItem> with TickerProviderStateMixin {

  bool _isRunning = false;
  

  // The timer
  Timer? _timer;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    
      if(!widget.isPaused){
        _startTimer();
      }
  }




  void _startTimer() {
   if(mounted){
     setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(mounted){
        setState(() {
        if (widget.seconds > 0) {
          widget.seconds--;
        } else {
          if (widget.minutes > 0) {
            widget.minutes--;
            widget.seconds = 59;
          } else {
            if (widget.hours > 0) {
              widget.hours--;
              widget.minutes = 59;
              widget.seconds = 59;
            } else {
              _isRunning = false;
              _timer?.cancel();
            }
          }
        }
      });
      }
    });
   }
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  // This function will be called when the user presses the cancel button
  // Cancel the timer
  // void _cancelTimer() {
  //   setState(() {
  //     widget.hours = 0;
  //     _minutes = 0;
  //     _seconds = 0;
  //     _isRunning = false;
  //   });
  //   _timer?.cancel();
  // }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: Styles.containerDecoration,
      child: Padding(padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(widget.selectedDevice),
            ),
            Row(
              children: [
                BlinkingDotWidget(isRunning: _isRunning),
               Text(
                  '${widget.hours.toString().padLeft(2, '0')}:${widget.minutes.toString().padLeft(2, '0')}:${widget.seconds.toString().padLeft(2, '0')}',
                  
                )
              ],
            ),
            widget.isPaused? 
            ElevatedButton(
              style: Styles.primaryButtonStyle,
              onPressed: (){
                setState(() {
                  _startTimer();
                  widget.isPaused = false;
                });
              }, 
              child: Icon(Icons.play_arrow, color: ThemeColors.secondaryBackground,)):
            ElevatedButton(
              style: Styles.errorButtonStyle,
              onPressed: (){
                setState(() {
                  _pauseTimer();
                  widget.isPaused =true;
                });
              }, 
              child: Icon(Icons.pause, color: ThemeColors.secondaryBackground,))
          ],
        ),
      ),
    );
  }



}