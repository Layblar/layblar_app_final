
import 'package:ass/API/APIController.dart';
import 'package:ass/DTO/Device/DeviceDTO.dart';
import 'package:ass/DTO/SmartMeter/SmartMeterDataDTO.dart';
import 'package:ass/HelperClasses/StatusCodes.dart';
import 'package:ass/Services/TokenCheckService.dart';
import 'package:ass/WIdgets/BottomToast.dart';
import 'package:flutter/material.dart';
import 'package:ass/HelperClasses/DataPoint.dart';
import 'package:ass/Themes/Styles.dart';
import 'package:ass/Themes/ThemeColors.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;
import 'package:syncfusion_flutter_sliders/sliders.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';



class ChartScreen extends StatefulWidget {
  const ChartScreen({ Key? key }) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {


  final belowBarDataGradient = LinearGradient(colors: [ThemeColors.primary.withOpacity(0.8), ThemeColors.secondary.withOpacity(0.8)]);


  String startTime = "";
  String endTime = "";

  bool isStartTimeEnabled = false;
  bool isEndTimeEnabled = false;

  int? selectedStartIndex;
  int? selectedEndIndex;

  bool isOneHourSelected =true;
  bool isSixHoursSelected = false;
  bool isTwentyFourHoursSelected = false;

  String selectedDevice = "";
  bool isDeviceSelected = false;
  late DeviceDTO? deviceDTO;

  bool isChartSelectionEnabled = true;

  List<DropdownMenuItem<String>> dropdownItems = [];


  late Future<List<DeviceDTO>> _devices;

  late Key chartKey;

  final int ONE_HOUR = 1;
  final int SIX_HOURS = 6;
  final int TWENTYFOUR_HOURS = 24;


  late DateTime selectedStartDate;
  late DateTime selectedEndDate;



  List<SmartMeterDataDTO> smartMeterData = [];
  List<DataPoint> chartData = [];
  DateTime dateMin = DateTime.now();
  DateTime dateMax = DateTime.now();
  late SfRangeValues dateValues; 
  int selectedTimeRange = 0;


  @override
  void initState() {
  super.initState();
      chartKey = UniqueKey(); // Fügen Sie dies zur Initialisierung hinzu

  selectedTimeRange = ONE_HOUR;
  dateValues = SfRangeValues(
    DateTime.now().subtract(Duration(hours: 1)), // Startdatum basierend auf selectedTimeRange
    DateTime.now(),
  );  
  fetchSmartMeterData(selectedTimeRange);
  _devices = getAllDevices();
  deviceDTO = null;
  
  }

   Future<void> fetchSmartMeterData(int hours) async {
    try {
      List<SmartMeterDataDTO> data = await getSmartMeterData(hours);
      setState(() {
        
        smartMeterData = data;
        chartData = getChartDataPoints(smartMeterData);
        dateMin = chartData[0].time;
        dateMax = chartData[chartData.length -1].time;
        dateValues = SfRangeValues(dateMin, dateMax);

        chartKey = UniqueKey(); // Aktualisieren Sie den Schlüssel

        selectedStartDate = dateMin;
        selectedEndDate = dateMax;

        
  
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }


  @override
  Widget build(BuildContext cogntext) {

    return  FutureBuilder(
      future: _devices,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return  const Center(child: SizedBox(height: 32, width: 32, child: CircularProgressIndicator()));
        }else if(snapshot.hasError){
          return Text('Error ${snapshot.error}');
        }else{
          List<DeviceDTO> deviceList = snapshot.data!;
          return Column(
            children: [
              Expanded(
                flex: 1,
                child:getSetDeviceSection(deviceList),
              ),
              Expanded(
                flex: 1,
                child: getTimeFilterSection()
              ),
              Expanded(
                flex: 5,
                child: getChartWithSliderSection(dateMin, dateMax, dateValues, chartData),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: double.infinity,
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      getTimeSection(),
                      getResetSubmitBtnSection(),
                    ]
                  )
                ),
              )
            ],
          );
        }
      },
    );
  }


  Future<List<SmartMeterDataDTO>> getSmartMeterData(int hours)async{
    List<SmartMeterDataDTO> smData = [];
    String? token = await APIController.getTokenFromSharedPreferences();
    if(token != null){
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        if(JwtDecoder.isExpired(token)){
          TokenCheckService.navigateBackIfTokenIsExpired(context);
        }else{
            String householdId = decodedToken['householdId'];

            var currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
            var twentyFourHoursInMillis = Duration(hours: hours).inMilliseconds;
            var twentyFourHoursAgo = currentTimeMillis - twentyFourHoursInMillis;
            // Unix-Timestamp als String
            String fromTimestamp = (twentyFourHoursAgo / 1000).toString();
            String toTimestamp = (currentTimeMillis / 1000).toString();

            var fromParts = fromTimestamp.split('.');
            String from = fromParts[0];

            var toParts = toTimestamp.split('.');
            String to = toParts[0];
            smData = await APIController.getSmartMeterData(token, householdId, from, to);
        }
    }
    return smData;

  }
  List<DataPoint> getChartDataPoints(List<SmartMeterDataDTO> smartMeterData){

    List<DataPoint> dataPoints = [];
    for(SmartMeterDataDTO s in smartMeterData){

      DateTime dateTime = DateTime.parse(s.time);
      DateTime oneHourEarlier = dateTime.add(Duration(hours: 1)); //TODO: only temporary!

      DateFormat outputFormat = DateFormat('yyyy:MM:dd:HH:mm');
      String formattedDate = outputFormat.format(oneHourEarlier);
      DateTime parsedDateTime = DateFormat('yyyy:MM:dd:HH:mm').parse(formattedDate);
      dataPoints.add(DataPoint(parsedDateTime, s.value1_7_0));
    }
    return dataPoints;
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


  Future<void>addLabebeledData(DeviceDTO? device, DateTime start, DateTime end)async{


    //Close the dialog
    Navigator.of(context).pop();
    String? token = await APIController.getTokenFromSharedPreferences();


    if(token != null){
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        if(JwtDecoder.isExpired(token)){
          TokenCheckService.navigateBackIfTokenIsExpired(context);
        }else{

            if(deviceDTO == null){
              BottomToast.showToast("Please select a Device first!");
              return;
            }
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

            int response = await APIController.addLabeledData(token, householdId, deviceDTO!, smartMeterData);

            if(response == StatusCodes.CREATED){
             resetScreen();
              BottomToast.showToast("New Device successfully added!");
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



/////////////////////////////////UI////////////////////////////////////////////////
  Container getSetDeviceSection(List<DeviceDTO> deviceList) {
    return Container(
              margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 0),
                decoration: Styles.containerDecoration,
                child: Row(
                  children: [
                   
                    Expanded(flex: 5, 
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: ()=> showDropDownList(deviceList),
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
                deviceDTO = e;
              });
              Navigator.of(context).pop();
            },
          ))
          .toList()
        ),
      );
    });
  }

   Container getTimeFilterSection() {

    void toggleTimeFilter(String time){
    if(time == "one"){
      setState(() {
        selectedTimeRange = ONE_HOUR;
        isOneHourSelected =true;
        isSixHoursSelected = false;
        isTwentyFourHoursSelected = false;
      });
    }else if(time == "six"){
      setState(() {
        selectedTimeRange = SIX_HOURS;
        isOneHourSelected =false;
        isSixHoursSelected = true;
        isTwentyFourHoursSelected = false;
      });
    }else if(time == "twentyfour"){
      setState(() {
        selectedTimeRange = TWENTYFOUR_HOURS;
        isOneHourSelected =false;
        isSixHoursSelected = false;
        isTwentyFourHoursSelected = true;
      });
    }
    // Fetch data based on selected time range
  fetchSmartMeterData(selectedTimeRange);

  // Update dateValues based on the selected time range
 
  }
    return Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
          decoration: Styles.containerDecoration,
          child: Row(
            children: [
              Expanded(flex:1, 
              child: GestureDetector(
                onTap: ()=> toggleTimeFilter("one"),
                child: Container(
                  decoration: isOneHourSelected?Styles.selctedContainerDecoration:null,
                  child:  Center(
                    child: Text("Last Hour" , style: TextStyle(color: isOneHourSelected? ThemeColors.secondaryBackground: ThemeColors.textColor)),)),
                ),
              ),
              Expanded(
                flex:1,
                child: GestureDetector(
                  onTap: ()=> toggleTimeFilter("six"),
                  child: Container(
                    decoration: isSixHoursSelected?Styles.selctedContainerDecoration:null,
                  child:  Center(
                    child: Text("Last 6 hours", style: TextStyle(color: isSixHoursSelected?ThemeColors.secondaryBackground: ThemeColors.textColor),),)),
                ),
              ),
              Expanded(
                flex:1, 
                child: GestureDetector(
                  onTap: ()=> toggleTimeFilter("twentyfour"),
                  child: Container(
                    decoration: isTwentyFourHoursSelected?Styles.selctedContainerDecoration:null,
                    child:  Center(
                      child: Text("Last 24 Hours" , style: TextStyle(color: isTwentyFourHoursSelected?ThemeColors.secondaryBackground: ThemeColors.textColor)),)),
                  ),
              ),
            ],
          ),
        );
    }

  

  Widget getChartWithSliderSection(DateTime dateMin, DateTime dateMax, SfRangeValues dateValues, List<DataPoint> chartData) {
    return
                       Container(
                        child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Center(
                            // ignore: missing_required_param
                              child: SfRangeSelector(
                                key: chartKey,
                                min: dateMin,
                                max: dateMax,
                                initialValues: dateValues,
                                interval: 1,
                                dateIntervalType: DateIntervalType.hours,
                                dateFormat: DateFormat.H(),
                                showTicks: true,
                                showLabels: false,
                                onChanged: (SfRangeValues values){
                                  setState(() { 
                                    startTime = DateFormat('HH:mm').format(values.start);
                                    endTime =  DateFormat('HH:mm').format(values.end);
                                    selectedStartDate = values.start;
                                    selectedEndDate = values.end;
                                    
                                    dateValues = values; 
                                 });
                                },
                                child: SizedBox(
                                  child: SfCartesianChart(
                                   key: chartKey, 
                                    margin: EdgeInsets.zero,
                                    primaryXAxis: DateTimeAxis(
                                      minimum: dateMin,
                                      maximum: dateMax,
                                      isVisible: true,
                                    ),
                                    primaryYAxis: NumericAxis(
                                      name: "kw/h",
                                      isVisible: true, 
                                      maximum: (getMaxEngeryConsumtion(chartData) + 1) //for a little extra padding ;)
                                    ),
                                    series: <SplineAreaSeries<DataPoint, DateTime>>[
                                      SplineAreaSeries<DataPoint, DateTime>(
                                       gradient: belowBarDataGradient,
                                         dataSource: chartData,
                                         xValueMapper: (DataPoint p, int index) => p.time,
                                         yValueMapper: (DataPoint p, int index) => p.energyConsumption)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    );
    }

   Container getTimeSection() {
    return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(8),
                decoration: Styles.containerDecoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                  children: [
                     Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                           const Expanded(flex: 3, child:  Text("Start:")),
                          Expanded(
                            flex: 7,
                            child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              decoration:Styles.primaryBackgroundContainerDecoration,
                              child: Center(
                                child: Text(startTime)))),
                        ],
                      ),
                    ),
                   Expanded(
                     flex: 1, 
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Row(
                            children: [
                              const Expanded(flex: 3, child:  Text("End:")),
                              Expanded(
                                flex: 7,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration:Styles.primaryBackgroundContainerDecoration,
                                  child: Center(
                                    child: Text(endTime)))),
                            ],
                          ),
                     ),
                   ),
                   
                  ],
                )
              );
    }

  Container getResetSubmitBtnSection() {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      decoration: Styles.containerDecoration,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: ()=> onReset(), 
                style: Styles.errorButtonStyle,
                child:  Text("Reset", style: Styles.secondaryTextStyle,), 
              ),
            )
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: ()=>
                  deviceDTO == null ? BottomToast.showToast("No Device Selected!")
                  : showDialog(context: context, builder: (BuildContext context){
                    return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,

                      child: AlertDialog(
                        backgroundColor: ThemeColors.secondaryBackground,
                        title: Text("Please confirm your Label!", style: Styles.infoBoxTextStyle,),
                        content: Text("Device: ${deviceDTO!.deviceName}, from $startTime to $endTime"),

                        actions: [
                          ElevatedButton( style: Styles.errorButtonStyle,  onPressed: ()=> Navigator.of(context).pop(), child: Text("Cancel", style: Styles.secondaryTextStyle)),
                          ElevatedButton( style: Styles.primaryButtonStyle,  onPressed: ()=> addLabebeledData(deviceDTO, selectedStartDate, selectedEndDate), child: Text("Add Label", style: Styles.secondaryTextStyle))
                        ],
                      ),
                    );
                }), 
                style: Styles.primaryButtonStyle,
                child:  Text("Save Label" , style: Styles.secondaryTextStyle), 
              ),
            )
          ),
        ],
      ),
    );
  }


  void enableStartTime(){
    isEndTimeEnabled = false;
    isStartTimeEnabled = true;
  }

  void enableEndTime(){
    isStartTimeEnabled = false;
    isEndTimeEnabled = true;
  }

  void resetScreen (){
    setState(() {
      isEndTimeEnabled = false;
      isStartTimeEnabled = false;
      startTime = "";
      endTime = "";
      selectedStartIndex = null;
      selectedEndIndex = null;
       deviceDTO = null;
      selectedDevice = "";
    });
  }

  void onReset (){
    setState(() {
      isEndTimeEnabled = false;
      isStartTimeEnabled = false;
      startTime = "";
      endTime = "";
      selectedStartIndex = null;
      selectedEndIndex = null;
      selectedDevice = "";
    });
  }
}




