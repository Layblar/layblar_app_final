// ignore: file_names
import 'package:ass/DTO/FAQItemDTO.dart';
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



  //Mocked Projects
  List<FAQItemDTO>allFAQs = FAQItemDTO.generateMockedFAQS();
  List<String> availableProjects = [];

  bool isFAQOpened = false;
  bool isManageProjectsOpened = false;

  void toggleFAQView(){
    if(isFAQOpened){
      setState(() {
        isFAQOpened = false;
      });
    }else{
      setState(() {
        isFAQOpened = true;
      });
    }
  }

  void toggleManageProjectsView(){
     if(isManageProjectsOpened){
      setState(() {
        isManageProjectsOpened = false;
      });
    }else{
      setState(() {
        isManageProjectsOpened = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    availableProjects = ["Project 1, Project 2, Project 3"];
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
          //TODO: fetch user info
          children: [
            Text("Logged in as", style: Styles.regularTextStyle,),
            Text("Richard Lorenz", style: Styles.headerTextStyle,),
           
            GestureDetector(
              onTap: ()=> toggleFAQView(),
              child: Container(
                child:  Row(
                  children: [
                    const Text("FAQ"),
                    Icon(isFAQOpened? Icons.arrow_drop_up:Icons.arrow_drop_down, color: ThemeColors.textColor,),
                  ],
                ),
              ),
            ),
            isFAQOpened? Expanded(
              child: ListView.builder(itemCount: allFAQs.length, itemBuilder: (context, index){
                            return ListTile(
                              title: Text(allFAQs[index].question),
                              subtitle: Text(allFAQs[index].answer),
                            );
                          }),
            ): const SizedBox(),
           ElevatedButton( style: Styles.primaryButtonStyle, onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> const AddDeviceScreen())), child: Text("Add new Device", style: Styles.secondaryTextStyle,)),
            ElevatedButton( style: Styles.secondaryButtonStyle, onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> const ManageProjectsScreen())), child: Text("Manage Projects", style: Styles.secondaryTextStyle,))

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


//TODO: apply logic so the household updates, amybe a new call etc
  void navigateBack(){
    Navigator.of(context).pop();
  }

  void logout(){
    Navigator.of(context).push(MaterialPageRoute(builder: ((BuildContext context) => const LoginScreen())));
  }


  //TODO: Dynamic projects
  void openProjectsDialoge(){
    debugPrint("[-------CURRENT----]" +  widget.currentProject);
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text("Change Project"),
        content:Column(
          mainAxisSize: MainAxisSize.min,
          children: 
              availableProjects.map((e) => GestureDetector(
                onTap: () => setState(() {
                
                }),
                child: Container(
                  color: widget.currentProject == e? ThemeColors.primary: ThemeColors.primaryBackground,
                  child: ListTile(title: Text(e, style: TextStyle(color: widget.currentProject == e? ThemeColors.primaryBackground: ThemeColors.textColor,),)),
                          ),
              )).toList(),
        ),
        actions: [
          ElevatedButton(onPressed: ()=> Navigator.of(context).pop(), child: const Text("Cancel"), style: Styles.errorButtonStyle,),
          ElevatedButton(onPressed: (){}, child: const Text("Change Project"), style: Styles.primaryButtonStyle,)
        ],
      );
    });
  }

  
}