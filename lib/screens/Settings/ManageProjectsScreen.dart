import 'package:ass/API/APIController.dart';
import 'package:ass/DTO/Device/DeviceCategoryDTO.dart';
import 'package:ass/DTO/Device/DeviceDTO.dart';
import 'package:ass/DTO/Label/LabelDTO.dart';
import 'package:ass/DTO/Project/ProjectDTO.dart';
import 'package:ass/DTO/Project/ProjectMetaDataDTO.dart';
import 'package:ass/HelperClasses/StatusCodes.dart';
import 'package:ass/Services/TokenCheckService.dart';
import 'package:ass/Themes/Styles.dart';
import 'package:ass/Themes/ThemeColors.dart';
import 'package:ass/WIdgets/BottomToast.dart';
import 'package:ass/screens/Settings/AddDeviceScreen.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ManageProjectsScreen extends StatefulWidget {
  const ManageProjectsScreen({super.key});

  @override
  State<ManageProjectsScreen> createState() => _ManageProjectsScreenState();
}

class _ManageProjectsScreenState extends State<ManageProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Manage Projects"), backgroundColor: ThemeColors.secondaryBackground,),
      backgroundColor: ThemeColors.secondaryBackground,
      body: FutureBuilder(
        future: getHouseholdDevices(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return  const Center(child: SizedBox(height: 32, width: 32, child: CircularProgressIndicator()));
          }else if(snapshot.hasError){
            return Text('Error ${snapshot.error}');
          }else{
            List<DeviceCategoryDTO> allHouseholCategories = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                Text("Projects you've already joined", style: Styles.regularTextStyle,),
                Expanded(
                  child: FutureBuilder(
                  future: getAlreadyJoinedProjects(), 
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return  const Center(child: SizedBox(height: 32, width: 32, child: CircularProgressIndicator()));
                    }else if(snapshot.hasError){
                      return Text('Error ${snapshot.error}');
                    }else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("No Projects");    
                    }else{
                      List<ProjectDTO> alreadyJoinedProjects = snapshot.data!;
                      return ListView.builder(
                        itemCount: alreadyJoinedProjects.length,
                        itemBuilder: (context, index){
                          ProjectDTO p = alreadyJoinedProjects[index];
                          return Column(
                            children: [
                              Container(
                                decoration: Styles.primaryBackgroundContainerDecoration,
                                child: ListTile(
                                  title: Text(p.projectName, style: Styles.regularTextStylePrimaryColor,),
                                  subtitle: Text(p.projectDescription, style: Styles.regularTextStyle),
                                  trailing: IconButton(icon: Icon(Icons.delete, color: ThemeColors.textColor,), onPressed: ()=> showDialog(
                                    context: context, builder: (BuildContext context){
                                      return AlertDialog(
                                        backgroundColor: ThemeColors.secondaryBackground,
                                        title: Text("Are you sure you want to leave this Project?", style: Styles.infoBoxTextStyle,),
                                        actions: [
                                          ElevatedButton(style:Styles.errorButtonStyle, onPressed: ()=> Navigator.of(context).pop(), child: Text("No", style: Styles.secondaryTextStyle)),
                                          ElevatedButton(style:Styles.primaryButtonStyle, onPressed: (){}, child: Text("Yes", style: Styles.secondaryTextStyle))
                                        ],
                                      );
                                    }),),
                                ),
                              ),
                              const SizedBox(height: 32)
                            ],
                          );
                          }
                        );
                      }
                    }
                  ),
                ),
                Text("Projects you can join"),
                Expanded(
                  child: FutureBuilder(
                    future: getJoinableProjects(), 
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return  const Center(child: SizedBox(height: 32, width: 32, child: CircularProgressIndicator()));
                      }else if(snapshot.hasError){
                        return Text('Error ${snapshot.error}');
                      }else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("No Projects");    
                      }else{
                        List<ProjectDTO> joinableProjects = snapshot.data!;
                        return ListView.builder(
                          itemCount: joinableProjects.length,
                          itemBuilder: (context, index){
                            ProjectDTO p = joinableProjects[index];
                            List<DeviceCategoryDTO> projectCategories = [];
                            List<DeviceCategoryDTO> householdCategories = allHouseholCategories;

                  
                            //Hier brauche ich funktion um alle categories herauszuholn und die mit meinem haushault abzugleichen
                            List<LabelDTO> labels = p.labels;
                            for(LabelDTO l in labels){
                              List<DeviceCategoryDTO> categories = l.categories;
                                for(DeviceCategoryDTO c in categories){
                                  projectCategories.add(c);
                                }
                            }

                            Set<DeviceCategoryDTO> categoriesNotInHouseholdSet = Set<DeviceCategoryDTO>.from(
                              projectCategories.where((projectCategory) =>
                                !householdCategories.any((householdCategory) => householdCategory.categoryId == projectCategory.categoryId)),
                              );

                            List<DeviceCategoryDTO> categoriesNotInHousehold = categoriesNotInHouseholdSet.toList();

                            for(DeviceCategoryDTO d in categoriesNotInHousehold){
                              debugPrint("Category: " + d.categoryName + ", " + d.categoryId + ", " + p.projectName);
                            }


                            debugPrint(categoriesNotInHousehold.length.toString() + " missing for project " + p.projectName);
                          
                            return Column(
                              children: [
                                Container(
                                  decoration: Styles.primaryBackgroundContainerDecoration,
                                  child: ListTile(
                                    title: Text(p.projectName, style: Styles.regularTextStylePrimaryColor,),
                                    subtitle: 
                                    categoriesNotInHousehold.isEmpty?
                                      Text(p.projectDescription, style: Styles.regularTextStyle,)
                                      :Text("${categoriesNotInHousehold.length} Categories missing", style: Styles.regularTextStyle),
                                    trailing: 
                                    categoriesNotInHousehold.isEmpty ?
                                      ElevatedButton(style: Styles.primaryButtonStyle, onPressed: (){
                                        showDialog(context: context, builder: (BuildContext context){
                                          return AlertDialog(
                                            backgroundColor: ThemeColors.secondaryBackground,
                                            title: Text("Do you want to join this Project?", style: Styles.infoBoxTextStyle,),
                                            actions: [
                                              ElevatedButton(style: Styles.errorButtonStyle, onPressed: ()=> Navigator.of(context).pop(), child: Text("No", style: Styles.secondaryTextStyle,)),
                                              ElevatedButton(style: Styles.primaryButtonStyle, onPressed: ()=> joinProject(p.projectId, p.metaData), child: Text("Yes", style: Styles.secondaryTextStyle))
                                            ],
                                          );
                                        });
                                      }, child: Text("Join", style: Styles.secondaryTextStyle,))
                                    : IconButton(onPressed: (){
                                      showDialog(context: context, builder: (BuildContext context){
                                        return AlertDialog(
                                          backgroundColor: ThemeColors.secondaryBackground,
                                          title: Text("Categories missing for Project ${p.projectName}", style: Styles.infoBoxTextStyle,),
                                          content: SizedBox(
                                          width: double.maxFinite,
                                          child: ListView.builder(
                                            itemCount: categoriesNotInHousehold.length,
                                            itemBuilder: (context, index) {
                                              DeviceCategoryDTO element = categoriesNotInHousehold[index];
                                              return Text(element.categoryName);
                                            },
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton( style:Styles.errorButtonStyle, onPressed: ()=> Navigator.of(context).pop(), child: Text("Close", style: Styles.secondaryTextStyle,)),
                                          ElevatedButton( style:Styles.primaryButtonStyle, onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> const AddDeviceScreen())), child: Text("Add Device(s)", style: Styles.secondaryTextStyle,))
                                        ],
                                        );
                                    });
                                    }, icon:  Icon(Icons.info, color: ThemeColors.primary,)),
                                  ),
                                ),
                              const SizedBox(height: 16)
                              ],
                            );
                        });
                      }
                    }
                  ),
                ),               
              ]
            );
          }
        }
      ),
    );

  }



  Future<List<ProjectDTO>> getAlreadyJoinedProjects() async{

      String? token = await APIController.getTokenFromSharedPreferences();
      List<ProjectDTO> alreadyJoinedProjects = [];
      if(token != null){
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        if(JwtDecoder.isExpired(token)){
          TokenCheckService.navigateBackIfTokenIsExpired(context);
        }else{
            String householdId = decodedToken['householdId'];
            alreadyJoinedProjects = await APIController.getAllProjects(token, householdId: householdId);
            debugPrint("[------alreadyJoinedProjects------]$alreadyJoinedProjects");
        }
      }
      return alreadyJoinedProjects;
  }

  Future<List<ProjectDTO>> getJoinableProjects() async{
      String? token = await APIController.getTokenFromSharedPreferences();
      List<ProjectDTO> joinableProjects = [];
      if(token != null){
        if(JwtDecoder.isExpired(token)){
          TokenCheckService.navigateBackIfTokenIsExpired(context);
        }else{
            joinableProjects = await APIController.getAllProjects(token, isJoinable: true);
            debugPrint("[------joinableProjects------]$joinableProjects");
        }
      }
      return joinableProjects;
  }

  

  Future<void>joinProject(String projectId, List<ProjectMetaDataDTO> projectMetaData) async{
        String? token = await APIController.getTokenFromSharedPreferences();
        if(token != null){
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        if(JwtDecoder.isExpired(token)){
          TokenCheckService.navigateBackIfTokenIsExpired(context);
        }else{
            String householdId = decodedToken['householdId'];
            List<DeviceDTO> devices = await APIController.getHouseHoldDevices(token, householdId);
            int response = await APIController.joinProject(token, householdId, projectId, devices, projectMetaData);

            if(response == StatusCodes.OK){
           //Reset Page here
             BottomToast.showToast("New Device successfully added!");
             Navigator.of(context).pop();
             setState(() {});
            }else if(response == StatusCodes.UNAUTHORIZED){
             BottomToast.showToast("STH STRANGE HAPPENED$response");
            }else if(response == StatusCodes.INVALID_USER){
            BottomToast.showToast("STH STRANGE HAPPENED$response");
            }else if(response == StatusCodes.SERVER_ERROR){
            BottomToast.showToast("STH STRANGE HAPPENED$response");
            }else{
            BottomToast.showToast("STH STRANGE HAPPENED$response");
            }
        
        }
      }

  }

  Future<List<DeviceCategoryDTO>>getHouseholdDevices()async{
    String? token = await APIController.getTokenFromSharedPreferences();
    List<DeviceDTO> householdDevices = [];
    List<DeviceCategoryDTO> houseHoldDeviceCategories = [];

      if(token != null){
        if(JwtDecoder.isExpired(token)){
          TokenCheckService.navigateBackIfTokenIsExpired(context);
        }else{
            Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
            String householdId = decodedToken['householdId'];
            householdDevices = await APIController.getHouseHoldDevices(token, householdId);

            for( DeviceDTO device in householdDevices){
              for(DeviceCategoryDTO category in device.categories){
                houseHoldDeviceCategories.add(category);
              }
            }
        }
      }
      return houseHoldDeviceCategories;
  }


  
}