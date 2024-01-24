// ignore: file_names

import 'package:ass/Themes/Styles.dart';
import 'package:ass/screens/Main_Components/ChartScreen.dart';
import 'package:ass/screens/Main_Components/DetailsScreen.dart';
import 'package:ass/screens/Main_Components/LabelsScreen.dart';
import 'package:ass/screens/Settings/SettingsScreen.dart';
import 'package:flutter/material.dart';
import '../Themes/ThemeColors.dart';
import 'Main_Components/StopwatchScreen.dart';


class MainScreen extends StatefulWidget with WidgetsBindingObserver {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


   Widget _currentWidget = const TimerScreen();
   
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
            label: "Stopwatch",
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



  
 
}