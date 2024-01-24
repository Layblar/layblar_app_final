// ignore: file_names
import 'package:ass/screens/Login_Registration/RegisterSmartMeterScreen.dart';
import 'package:ass/screens/Settings/AddDeviceScreen.dart';
import 'package:ass/screens/Settings/ManageProjectsScreen.dart';
import 'package:flutter/material.dart';
import 'package:ass/Themes/Styles.dart';
import 'package:ass/Themes/ThemeColors.dart';

import '../Login_Registration/LoginScreen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({ required this.currentProject, Key? key }) : super(key: key);

  final String currentProject;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      appBar: AppBar(
        title:  Text("Settings", style: Styles.regularTextStyle,),
        centerTitle: true,
        backgroundColor: ThemeColors.secondaryBackground,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: ThemeColors.textColor,), onPressed: ()=> navigateBack(),),
      ),
      backgroundColor: ThemeColors.primaryBackground,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [           
            getAddNewDeviceButton(context),
            getManageProjectsButton(context),
            getAddSmartMeterButton(context), 
          ],
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: () => navigateBack(), style: Styles.secondaryButtonStyle, child:  Text("Back", style: Styles.secondaryTextStyle)),
          )),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: ()=> logout(),  style: Styles.errorButtonStyle, child: Text("Logout", style: Styles.secondaryTextStyle),),
          )),

        ],
      ),
    );
  }

  ElevatedButton getAddSmartMeterButton(BuildContext context) {
    return ElevatedButton( 
          style: Styles.tertiaryButtonStyle, 
          onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> const RegisterSmartMeterScreen())), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: ThemeColors.primaryBackground,),
              const SizedBox(width: 4),
              Text("Add Smart Meter", style: Styles.secondaryTextStyle,),
            ],
          ));
  }

  ElevatedButton getManageProjectsButton(BuildContext context) {
    return ElevatedButton( 
            style: Styles.secondaryButtonStyle, 
            onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> const ManageProjectsScreen())), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.manage_accounts, color: ThemeColors.primaryBackground,),
                const SizedBox(width: 4),
                Text("Manage Projects", style: Styles.secondaryTextStyle,),
              ],
            ));
  }

  ElevatedButton getAddNewDeviceButton(BuildContext context) {
    return ElevatedButton( 
           style: Styles.primaryButtonStyle, 
           onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> const AddDeviceScreen())), 
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(Icons.tv, color: ThemeColors.primaryBackground,),
               const SizedBox(width: 4),
               Text("Add new Device", style: Styles.secondaryTextStyle,),
             ],
           )
           );
  }


  void navigateBack(){
    Navigator.of(context).pop();
  }

  void logout(){
    Navigator.of(context).push(MaterialPageRoute(builder: ((BuildContext context) => const LoginScreen())));
  }
  
}