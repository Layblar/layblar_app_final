import 'package:ass/API/APIController.dart';
import 'package:ass/DTO/Device/DeviceDTO.dart';
import 'package:ass/DTO/Project/ProjectDTO.dart';
import 'package:ass/Services/TokenCheckService.dart';
import 'package:ass/screens/Settings/AddDeviceScreen.dart';
import 'package:ass/screens/Settings/ManageProjectsScreen.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../Themes/Styles.dart';
import '../../Themes/ThemeColors.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({ Key? key }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

bool isAboutViewSelected = true;
bool isDevicesViewSelected = false;

final String ABOUT_PAGE = "ABOUT";
final String DEVICE_PAGE = "DEVICE";


@override
  void initState() {
    super.initState();
    getAllProjects();
    getMyDevices();
  }

  Future<List<ProjectDTO>>getAllProjects()async{
    String? token = await APIController.getTokenFromSharedPreferences();
    if(token != null){
        if(JwtDecoder.isExpired(token)){
          TokenCheckService.navigateBackIfTokenIsExpired(context);
        }else{
            Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
            String householdId = decodedToken['householdId'];
            List<ProjectDTO> response = await APIController.getAllProjects(token, householdId: householdId);
            return response;
        }
    }
    return [];
  }


  Future<List<DeviceDTO>> getMyDevices()async{
      String? token = await APIController.getTokenFromSharedPreferences();
       if(token != null){
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        if(JwtDecoder.isExpired(token)){
             TokenCheckService.navigateBackIfTokenIsExpired(context);
        }else{
            String householdId = decodedToken['householdId'];
            List<DeviceDTO> myDevices = await APIController.getHouseHoldDevices(token, householdId);
            return myDevices;
        }
    }
    return [];
  }




//about the project
  @override
  Widget build(BuildContext context) {

    //header seaction
    //project -- devices
    return   Column(
      children: [
        Expanded(
          flex: 1,
          child: getToggleViewSection()
        ),
        Expanded(
          flex: 8,
          child: isAboutViewSelected? getAboutSection() : getDeviceListSection()
        )
      ],
    );
  }



  void  moveToAddDeviceView(){
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const AddDeviceScreen()));
  }

  Container getDeviceListSection() {
    return Container(
      width: double.infinity,
          decoration: Styles.containerDecoration,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child:  Column(
              children: [
               const  SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder<List<DeviceDTO>>(
                    future: getMyDevices(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: SizedBox( height: 32, width: 32, child: CircularProgressIndicator())); // Show loading indicator while data is being fetched
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Column(
                          children: [
                            Text("You havent added any Devices yet.", style: Styles.regularTextStyle,),
                            const SizedBox(height: 8),
                            GestureDetector(onTap: ()=> moveToAddDeviceView(), child: Text("Add Devices", style:  Styles.regularTextStylePrimaryColor,)),
                          ],
                        );
                      } else {
                        List<DeviceDTO> myDevices = snapshot.data!;
                  
                        return ListView.builder(
                          itemCount: myDevices.length,
                          itemBuilder: (context, index) {
                            DeviceDTO device = myDevices[index];
                              return ListTile(
                                title: Text(device.deviceName, style: Styles.regularTextStylePrimaryColor,),
                                subtitle: device.deviceDescription == "null" ? Text("No description available", style: Styles.regularTextStyle): Text(device.deviceDescription, style: Styles.regularTextStyle,),
                                // Add more details or customize the ListTile as needed
                              );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
  }

  Widget getAboutSection() {

    Future<List<ProjectDTO>> _projectsFuture = getAllProjects();

    return Container(
      width: double.infinity,
       decoration: Styles.containerDecoration,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<ProjectDTO>>(
                future: _projectsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: SizedBox( height: 32, width: 32, child: CircularProgressIndicator())); // Show loading indicator while data is being fetched
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Column(
                      children: [
                          const SizedBox(height: 16,),
                          const Text('You havent joined any Projects yet!'),
                          const SizedBox(height: 8,),
                          GestureDetector(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> const ManageProjectsScreen())), child: Text("Join Projects", style: Styles.regularTextStylePrimaryColor,)),
                      ],
                    );
                  } else {
                    List<ProjectDTO> projects = snapshot.data!;
              
                    return ListView.builder(
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        ProjectDTO project = projects[index];
                        return Column(
                          children: [
                            Container(
                              decoration: Styles.primaryBackgroundContainerDecoration,
                              child: ListTile(
                                title: Text(project.projectName, style: Styles.regularTextStylePrimaryColor,),
                                subtitle: Text(project.projectDescription, style: Styles.regularTextStyle,),
                                // Add more details or customize the ListTile as needed
                              ),
                            ),
                            const SizedBox(height: 16)
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
            GestureDetector(
              onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> const ManageProjectsScreen())),
              child: Text("Manage Projects", style: Styles.regularTextStylePrimaryColor)),
          ],
        ),
      ),
    );
  }

  Container getToggleViewSection() {
    return Container(
        margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
        decoration: Styles.containerDecoration,
        child: Row(
          children: [
            Expanded(flex:1, 
            child: GestureDetector(
              onTap: ()=> toggleView(ABOUT_PAGE),
              child: Container(
                decoration: isAboutViewSelected?Styles.selctedContainerDecoration:null,
                child:  Center(
                  child: Text("My Projects" , style: TextStyle(color: isAboutViewSelected? ThemeColors.secondaryBackground: ThemeColors.textColor)),)),
            ),),
            Expanded(
              flex:1,
              child: GestureDetector(
                onTap: ()=> toggleView(DEVICE_PAGE),
                child: Container(
                  decoration: isDevicesViewSelected?Styles.selctedContainerDecoration:null,
                child:  Center(
                  child: Text("My Devices", style: TextStyle(color: isDevicesViewSelected?ThemeColors.secondaryBackground: ThemeColors.textColor),),)),
              ),
            ),   
          ],
        ),
      );
  }


 void toggleView(String selectedView){

    if(selectedView == ABOUT_PAGE){
      setState(() {
       isAboutViewSelected = true;
       isDevicesViewSelected = false;
      });
    }else if(selectedView == DEVICE_PAGE){
      setState(() {
       isAboutViewSelected = false;
       isDevicesViewSelected = true;
      });
    }
 }
}