import 'package:flutter/material.dart';
import 'package:ass/Themes/ThemeColors.dart';

class BTMNavigationBar extends StatefulWidget {

  final String currentPage;
  final BuildContext ctx;
  const BTMNavigationBar({
    required this.currentPage,
    required this.ctx,
    Key? key,
  }) : super(key: key);

  @override
  State<BTMNavigationBar> createState() => _BTMNavigationBarState();
}

class _BTMNavigationBarState extends State<BTMNavigationBar> {
  bool _isDetailsCurrent = false;

  bool _isLabelsCurrent = false;

  bool _isChartCurrent = false;

  bool _isTimerCurrent = false;

  @override
  void initState() {
    // TODO: implement initState
    setCurrentPageIcon(widget.currentPage);
    super.initState();
  }

  void setCurrentPageIcon(String currentPage){
    debugPrint("[-----currentpage----]" + currentPage);
    switch (currentPage){
      case ("Details"): 
          _isDetailsCurrent = true; 
        break;
      case ("Labels"):
          _isLabelsCurrent = true; 
        break;
      case ("Chart"):
          _isChartCurrent = true;
        break;
      case ("Timer"):
          _isTimerCurrent = true;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items:  [
         BottomNavigationBarItem(
        icon: Icon(Icons.lens, color: _isDetailsCurrent?ThemeColors.primary:ThemeColors.secondary),
        label: "Details",
      ),
       BottomNavigationBarItem(
        icon: Icon(Icons.label, color: _isLabelsCurrent?ThemeColors.primary:ThemeColors.secondary),
        label: "Labels",
      ),
       BottomNavigationBarItem(
        icon: Icon(Icons.monitor, color: _isChartCurrent?ThemeColors.primary:ThemeColors.secondary),
        label: "Chart",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.watch, color: _isTimerCurrent?ThemeColors.primary:ThemeColors.secondary),
        label: "Timer"
      )
      ]
    
    );
  }
}