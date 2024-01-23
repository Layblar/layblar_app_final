
import 'dart:async';
import 'package:ass/API/APIController.dart';
import 'package:ass/DTO/Device/DeviceDTO.dart';
import 'package:ass/Services/NotificationService.dart';
import 'package:ass/Services/TokenCheckService.dart';
import 'package:ass/WIdgets/BottomToast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ass/DTO/DEviceCardMocksDTO.dart';
import 'package:ass/DTO/StopWatchHoldItem.dart';
import 'package:ass/Themes/Styles.dart';
import 'package:ass/Themes/ThemeColors.dart';
import 'package:ass/WIdgets/DeviceListItem.dart';
import 'package:ass/WIdgets/StopwatchItem.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';



class TimerScreen extends StatefulWidget {


  const TimerScreen({  Key? key }) : super(key: key);


  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with WidgetsBindingObserver  {

  // late Timer _timer;
  
  String selectedDevice = "";
  late DeviceDTO currentDevice;

  List<DeviceListItem> mockedItems = DeviceCardMockDTO.generateCards();
  List<DropdownMenuItem<String>> dropdownItems = [];

  List<StopWatchItem> stopwatchItems = [];
  //List<TimerItem> timerItems = [];

  late Future<List<DeviceDTO>> _devices;


  bool isStopWatchViewSelected = true;

  var timeValue = ""; 


  @override
  void initState() {
  super.initState();

  WidgetsBinding.instance.addObserver(this);

  _devices = getAllDevices();

  var stopwatchItemsModel = Provider.of<StopwatchItemsModel>(context, listen: false);

  stopwatchItems = stopwatchItemsModel.stopwatchItems;
  selectedDevice = mockedItems[0].title;
  

    for (var item in stopwatchItems) {
        if (!item.isPaused) {
          item.stopwatch.start();
        }
      }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Die App wechselt in den Hintergrund, sende die Benachrichtigung hier
      NotificationService.updateNotification(stopwatchItems);
    }
  }


  void removeStopwatchItem(StopWatchItem item) {
    var stopwatchItemsModel = Provider.of<StopwatchItemsModel>(context, listen: false);
    stopwatchItemsModel.removeStopwatchItem(item);
    debugPrint("sdfsdfsd");
  }


void onStopWatchItemDeleted() {
    setState(() {
      // Aktualisieren Sie hier die Zustände oder rufen Sie bei Bedarf eine Aktualisierung an.
    });
  }
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
        child: FutureBuilder(
          future: _devices,
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
            return  const Center(child: SizedBox( height: 32, width: 32, child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Stack(
              children: [
                Column(
                  children: [
                    //Expanded(flex: 1, child: getToggleWatchModeSection()),
                    Expanded(flex: 1, child: getSetDeviceSection(snapshot.data!)), 
                    Expanded(
                      flex: 6,
                      child: getStopWatchSection(),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: getSubmitBtnSection(context, selectedDevice),  
                ),
              ],
            );
          }
        }
        )
      );
  }

 

  Future<List<DeviceDTO>> getAllDevices()async{

    List<DeviceDTO> allDevices = [];
     String? token = await APIController.getTokenFromSharedPreferences();

    if(token != null){
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        if(JwtDecoder.isExpired(token)){
          TokenCheckService.navigateBackIfTokenIsExpired(context);
        }else{
            String householdId = decodedToken['householdId'];
            allDevices = await APIController.getHouseHoldDevices(token, householdId);

        }
    }
    return allDevices;
  }

  
  ////////////////UI Components//////////////////////////////
  

  Container getStopWatchSection() {
    return Container(
            margin: const EdgeInsets.all(8),
            key: UniqueKey(),
              child: ListView.builder(
                reverse: false, // Umkehrung der Liste
                itemCount: stopwatchItems.length,
                itemBuilder: (context, index) {
                  return stopwatchItems[index];
                },
            ),
    );
  }


   Container getSetDeviceSection(List<DeviceDTO> devices) {

  dropdownItems = devices
  .map((element) {
    return DropdownMenuItem(
      
      value: element.deviceId,
      child: ListTile(
        title: Text(element.deviceName, style: Styles.regularTextStyle),
      ),
    );
    }).toList();

    return Container(
              margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 0),
                decoration: Styles.containerDecoration,
                child: Row(
                  children: [
                   
                    Expanded(flex: 5, 
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8.0),
                      child: ElevatedButton(
                        onPressed: ()=> showDropDownList(devices),
                        style: Styles.secondaryButtonStyle, 
                        child:  Text(
                          selectedDevice== ""?"Choose Device":"Change Device",  
                          style: Styles.secondaryTextStyle)),
                      )
                    ),
                    Expanded(flex: 5, 
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle, size: 36, color: selectedDevice!= ""?ThemeColors.secondary : ThemeColors.primaryDisabled,),
                            const SizedBox(width: 8,),
                            Flexible(
                              child: Text(selectedDevice == "" ? "No Device selected" : selectedDevice, overflow: TextOverflow.ellipsis,))
                          ],
                        ),
                      )
                    ),
                  ],
                ),
              );
    }

   void showDropDownList(List<DeviceDTO> devices){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        backgroundColor: ThemeColors.secondaryBackground,
        title:  Text("Chose your Device from the List below.", style: Styles.infoBoxTextStyle,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: devices.isEmpty?
            [
              const Text("No Devices available")
              //TODO: go to projects and join or add devices
            ]
           :devices.map((e) => ListTile(
            title: Text(e.deviceName, style: Styles.regularTextStyle,),
            
            onTap: () {
              setState(() {
                selectedDevice = e.deviceName;
                currentDevice = e;
              });
              Navigator.of(context).pop();
            },
          ))
          .toList()
        ),
      );
    });
  }

  

  Widget getSubmitBtnSection(BuildContext context, String selectedDevice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric( vertical: 16.0, horizontal: 16.0),
          child: ElevatedButton(
                  onPressed: () => addNewStopWatchItem(stopwatchItems, selectedDevice),
                  style: Styles.primaryButtonRoundedStyle,
                  child:  Text("+", style: Styles.headerTextStyle,),  
                ),
        ),
      ],
    );
  }


  //functionality
  void addNewStopWatchItem(List<StopWatchItem> items, String selectedDevice){

    if(selectedDevice == ""){
      BottomToast.showToast("Choose a Device first!");
    }else{
      Stopwatch stopwatch = Stopwatch();
      var stopwatchItemsModel = Provider.of<StopwatchItemsModel>(context, listen: false);

      setState(() {
        var newItem = StopWatchItem(selectedDevice: currentDevice, stopwatch: stopwatch, onStopWatchItemDeleted: ()=> onStopWatchItemDeleted(),);
        stopwatchItemsModel.addStopwatchItem(newItem); // Add the last item to the model

      });
    }
  }

}











//////////////////////TIMER STUFF, CURRENTLY NOT IN USE///////////////////////////////////////////////
///
///
// Container getToggleWatchModeSection() {
  //   return Container(
  //       margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
  //       decoration: Styles.containerDecoration,
  //       child: Row(
  //         children: [
  //           Expanded(flex:1, 
  //           child: GestureDetector(
  //             onTap: (){
  //               if(!isStopWatchViewSelected){
  //                 setState(() {
  //                   isStopWatchViewSelected = true;
  //                 });
  //               }
  //             },
  //             child: Container(
  //               decoration: isStopWatchViewSelected? Styles.selctedContainerDecoration: null,
  //               child:  Center(
  //                 child: 
  //                 stopwatchItems.isEmpty? Text("Stopwatch", style: TextStyle(color: isStopWatchViewSelected?  ThemeColors.secondaryBackground:ThemeColors.textColor)): Text("Stopwatch (" + stopwatchItems.length.toString() + ")" , style: TextStyle(color: isStopWatchViewSelected?  ThemeColors.secondaryBackground:ThemeColors.textColor)),)),
  //           ),),
  //           Expanded(
  //             flex:1,
  //             child: GestureDetector(
  //               onTap: (){
  //                 if(isStopWatchViewSelected){
  //                   setState(() {
  //                     isStopWatchViewSelected = false;
  //                   });
  //                 }
  //               },
  //               child: Container(
  //                 decoration: !isStopWatchViewSelected ?Styles.selctedContainerDecoration: null,
  //               child:  Center(
  //                 child:timerItems.isEmpty?  Text("Timer", style: TextStyle(color:isStopWatchViewSelected?  ThemeColors.textColor: ThemeColors.secondaryBackground)): Text("Timer (" + timerItems.length.toString() + ")", style: TextStyle(color: !isStopWatchViewSelected?ThemeColors.secondaryBackground:ThemeColors.textColor),))),
  //             ),
  //           ),
           

  //         ],
  //       ),
  //     );
  // }


//  Container getTimerSection() {
//     return Container(
//       child: Column(
//         children: [
//            for (int i = 0; i < _timers.length; i++)
//               Column(
//                 children: [
//                   Text(
//                     'Timer $i: ${_timerSeconds[i]} seconds',
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () => _pauseTimer(i),
//                         child: Text('Pause'),
//                       ),
//                       const SizedBox(width: 8),
//                       ElevatedButton(
//                         onPressed: () => _resumeTimer(i),
//                         child: Text('Resume'),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//         ],
//       ),
//     );
//   }



  //currently not in use!!! isch ein scheiss mit dem timer
  // void _startNewTimer(String timeValue, String selectedDevice) {
  //   Timer newTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     int index = _timers.indexOf(timer);
  //     if (index != -1 && !_isTimerPaused[index]) {
  //       if (_timerSeconds[index] > 0) {
  //         setState(() {
  //           _timerSeconds[index]--;
  //         });
  //       } else {
  //         timer.cancel();
  //         _timerSeconds[index] = 60;
          
  //       }
  //     }
  //   });

  //   _timers.add(newTimer);
  //   _timerSeconds.add(convertTimeStringToSeconds(timeValue));
  //   _isTimerPaused.add(false);
  //   _timerdevices.add(selectedDevice);
  // }

  // void _pauseTimer(int index) {
  //   _isTimerPaused[index] = true;
  // }

  // void _resumeTimer(int index) {
  //   _isTimerPaused[index] = false;
  // }


  // void addNewTimerItem(String time, String selectedDevice){
  //   int totalseconds = convertTimeStringToSeconds(time);
  //   int hours = totalseconds ~/ 3600;
  //   int minutes = (totalseconds % 3600) ~/ 60;
  //   int seconds = totalseconds % 60;

  //   var timerItemsModel = Provider.of<TimerItemsModel>(context, listen: false);


  //   setState(() {

      


      //var newItem = TimerItem(selectedDevice: selectedDevice,hours: hours, minutes: minutes, seconds: seconds);
  //     timerItemsModel.addTimerItem(newItem);
  //   });
  // }


//   int convertTimeStringToSeconds(String timeString) {
//   // Zeit in Stunden:Minuten:Sekunden aufteilen
//   List<String> timeComponents = timeString.split(":");
  
//   // Extrahiere Stunden, Minuten und Sekunden
//   int hours = int.parse(timeComponents[0]);
//   int minutes = int.parse(timeComponents[1]);
//   int seconds = int.parse(timeComponents[2].split(".")[0]); // Entferne Millisekunden
  
//   // Berechne die Gesamtzeit in Sekunden
//   int totalSeconds = hours * 3600 + minutes * 60 + seconds;
  
//   return totalSeconds;
// }


// void openTimerPicker(String currentDevice){

//     if(currentDevice == ""){
//       showDialog(context: context, builder: (BuildContext context){
//         return chooseDeviceFirstDialog(context);

//       });
//     }else{
//        showDialog(context: context, builder: (BuildContext context){
//       return Dialog(
//           child: Container(
//             decoration: Styles.containerDecoration,
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Set Timer for: " + currentDevice,
//                   style: Styles.infoBoxTextStyle,
//                 ),
//                 const SizedBox(height: 8.0),
//                 CupertinoTheme(
//                   data: CupertinoThemeData(
//                     primaryColor: ThemeColors.primary,
//                     textTheme: CupertinoTextThemeData(
//                       pickerTextStyle: TextStyle(color: ThemeColors.textColor, fontSize: 18),
//                     ),
//                   ),
//                   child: CupertinoTimerPicker(
//                     mode: CupertinoTimerPickerMode.hm,
//                     onTimerDurationChanged: (value) {
//                       setState(() {
//                         timeValue = value.toString();
//                         debugPrint(timeValue);
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 8.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: ElevatedButton(
//                         style: Styles.errorButtonStyle,
//                         onPressed: () {
//                           Navigator.of(context).pop(); // Close the dialog
//                         },
//                         child: Text("Cancel", style: Styles.secondaryTextStyle,),
//                       ),
//                     ),
//                      Expanded(
//                       flex: 1,
//                        child: ElevatedButton(
//                         style: Styles.primaryButtonStyle,
//                         onPressed: () {
//                           //TODO: logic
//                               if(timeValue != "0:00:00.000000"){
//                                 _startNewTimer(timeValue, selectedDevice);
//                               }
//                               Navigator.of(context).pop(); // Close the dialog
//                           },
//                           child: Text("Done", style: Styles.secondaryTextStyle,),
//                         ),
//                      ),
//                   ],
//                 ),
               
//               ],
//             ),
//           ),
//         );
//     });
//     }
   
//   }



 
// }










