// ignore: file_names
import 'package:ass/API/APIController.dart';
import 'package:ass/DTO/Household/HouseholdDTO.dart';
import 'package:ass/Services/TokenCheckService.dart';
import 'package:ass/Themes/Styles.dart';
import 'package:ass/screens/Main_Components/ChartScreen.dart';
import 'package:ass/screens/Main_Components/DetailsScreen.dart';
import 'package:ass/screens/Main_Components/LabelsScreen.dart';
import 'package:ass/screens/Login_Registration/RegisterScreen.dart';
import 'package:ass/screens/Settings/SettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../Themes/ThemeColors.dart';
import 'Main_Components/StopwatchScreen.dart';


class MainScreen extends StatefulWidget with WidgetsBindingObserver {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


   Widget _currentWidget = TimerScreen();
   
  var _currentIndex = 0;

  var _currentScreenTitle = "Stopwatch Labeling";




  void _loadScreen(){
    switch (_currentIndex){
      case (0): return setState((){_currentWidget = const TimerScreen(); _currentScreenTitle = "Stopwatch Labeling";});
      case (1): return setState(() { _currentWidget = const ChartScreen(); _currentScreenTitle = "Chart Labeling";});
      case (2): return setState(() { _currentWidget = const LabelsScreen(); _currentScreenTitle = "My Labels";});
    case (3): return setState(() { _currentWidget = const DetailsScreen(); _currentScreenTitle = "Details" ;});
    }
  }
 
  void _openSettings(){
    Navigator.of(context).push(MaterialPageRoute(builder: ((BuildContext context) => const SettingsScreen(currentProject: "Project 1",))));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadHousehold();
    

  }
 
  @override
  Widget build(BuildContext context) {
    return PopScope(
     canPop: false,
      child: Scaffold(
        backgroundColor: ThemeColors.primaryBackground,
        appBar: AppBar(
          centerTitle: true,
          title:  Text(_currentScreenTitle, textAlign: TextAlign.center, style: Styles.regularTextStyle,),
          backgroundColor: ThemeColors.secondaryBackground,
          actions: [
            IconButton(icon: Icon(Icons.settings, color: ThemeColors.textColor,), onPressed: () => _openSettings(),)
          ],
          automaticallyImplyLeading: false,
          ),
        body: _currentWidget,
        bottomNavigationBar: 
        BottomNavigationBar(
          selectedItemColor: ThemeColors.primary,
          showUnselectedLabels: true,
          unselectedLabelStyle: TextStyle(color: ThemeColors.textColor),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            _loadScreen();
          },
        items:  [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer, color: _currentIndex == 0?ThemeColors.primary:ThemeColors.primaryDisabled),
            label: "Timer",
            backgroundColor: ThemeColors.secondaryBackground
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, color: _currentIndex == 1?ThemeColors.primary:ThemeColors.primaryDisabled),
            label: "Chart",
            backgroundColor: ThemeColors.secondaryBackground
          ),
         
          BottomNavigationBarItem(
            icon: Icon(Icons.more, color: _currentIndex == 2?ThemeColors.primary:ThemeColors.primaryDisabled),
            label: "Labels",
            backgroundColor: ThemeColors.secondaryBackground
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.menu_book, color: _currentIndex == 3?ThemeColors.primary:ThemeColors.primaryDisabled),
            label: "Details",
            backgroundColor: ThemeColors.secondaryBackground
          ),
        ]
      ),
    
      ),
    );
  }



  Future<void> loadHousehold()async{
    String? token = await APIController.getTokenFromSharedPreferences();

    if(token != null){
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        if(JwtDecoder.isExpired(token)){
          TokenCheckService.navigateBackIfTokenIsExpired(context);
        }else{
            String householdId = decodedToken['householdId'];
            HouseholdDTO? response = await APIController.getHousehold(token, householdId);
            debugPrint("[------Household------]${response?.devices.length}");

        }

    }else{
      //no token ever, register
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const RegisterScreen()));
    }
  }

 
}