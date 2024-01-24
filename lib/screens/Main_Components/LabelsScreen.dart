
import 'package:ass/API/APIController.dart';
import 'package:ass/DTO/Label/LabelDataDTO.dart';
import 'package:ass/Services/TokenCheckService.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../Themes/Styles.dart';

class LabelsScreen extends StatefulWidget {
  const LabelsScreen({ Key? key }) : super(key: key);

  @override
  State<LabelsScreen> createState() => _LabelsScreenState();
}

//einf ne lsite von dem ganzen mist den wir gelabelt haben (ev bearbeiten/löschen?)
class _LabelsScreenState extends State<LabelsScreen> {

  bool isTodaySelected =true;
  bool isWeekSelected = false;
  bool isMonthSelected = false;


  

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        //Expanded(flex: 1, child: getTimeFilterSection()),
        Expanded(flex: 8, child: Container(
          margin: const EdgeInsets.all(8),
          decoration: Styles.containerDecoration,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Here you can see all the Devices you've labeled", style: Styles.infoBoxTextStyle,),
                const SizedBox(height: 16,),
                Expanded(
                  child: FutureBuilder(
                    future: getAllLabels(),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return  const Center(child: SizedBox(height: 32, width: 32, child: CircularProgressIndicator()));
                      }else if(snapshot.hasError){
                        return Text('Error ${snapshot.error}');
                      }else{
                        List<LabeledDataDTO> allLabels = snapshot.data!;
                        if(allLabels.isEmpty){
                          return Text("No labels so far!", style: Styles.regularTextStyle,);                        }
                        return ListView.builder(
                          itemCount: allLabels.length,
                          itemBuilder: ((context, index) {
                              return Column(
                                children: [
                                  Container(
                                    decoration: Styles.primaryBackgroundContainerDecoration,
                                    child: ListTile(
                                      title: Text(allLabels[index].device.deviceName, style: Styles.regularTextStylePrimaryColor,),
                                      subtitle: Text("Created at: ${parseDate(allLabels[index].createdAt)}", style: Styles.regularTextStyle),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            })
                        );
                  
                  
                      }
                    }
                  ),
                )
              ],
            ),
          ),
        ))
      ],
    );
     
  }

  String parseDate(String date){
      DateTime originalDate = DateTime.parse(date);
      String formattedDate = "${originalDate.day.toString().padLeft(2, '0')}.${originalDate.month.toString().padLeft(2, '0')}.${originalDate.year} ${originalDate.hour.toString().padLeft(2, '0')}:${originalDate.minute.toString().padLeft(2, '0')}";
      return formattedDate;
  }


  Future<List<LabeledDataDTO>>getAllLabels()async{

    String? token = await APIController.getTokenFromSharedPreferences();
    List<LabeledDataDTO> allLabels = [];

     if(token != null){
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        if(JwtDecoder.isExpired(token)){
          TokenCheckService.navigateBackIfTokenIsExpired(context);
        }else{
            String householdId = decodedToken['householdId'];
            allLabels = await APIController.getLabeledData(token, householdId);
            allLabels.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        }
    }
    return allLabels;

  }





  // Container getTimeFilterSection() {

  //   void toggleTimeFilter(String time){
  //   if(time == "day"){
  //     setState(() {
  //       isTodaySelected =true;
  //       isWeekSelected = false;
  //       isMonthSelected = false;
  //     });
  //   }else if(time == "week"){
  //     setState(() {
  //       isTodaySelected =false;
  //       isWeekSelected = true;
  //       isMonthSelected = false;
  //     });
  //   }else if(time == "month"){
  //     setState(() {
  //       isTodaySelected =false;
  //       isWeekSelected = false;
  //       isMonthSelected = true;
  //     });
  //   }
    
  // }
  //   return Container(
  //         margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
  //         decoration: Styles.containerDecoration,
  //         child: Row(
  //           children: [
  //            Expanded(flex:1, 
  //             child: GestureDetector(
  //               onTap: ()=> toggleTimeFilter("day"),
  //               child: Container(
  //                 decoration: isTodaySelected?Styles.selctedContainerDecoration:null,
  //                 child:  Center(
  //                   child: Text("Today" , style: TextStyle(color: isTodaySelected? ThemeColors.secondaryBackground: ThemeColors.textColor)),)),
  //             ),),
  //             Expanded(
  //               flex:1,
  //               child: GestureDetector(
  //                 onTap: ()=> toggleTimeFilter("week"),
  //                 child: Container(
  //                   decoration: isWeekSelected?Styles.selctedContainerDecoration:null,
  //                 child:  Center(
  //                   child: Text("This Week", style: TextStyle(color: isWeekSelected?ThemeColors.secondaryBackground: ThemeColors.textColor),),)),
  //               ),
  //             ),
  //             Expanded(flex:1, 
  //             child: GestureDetector(
  //               onTap: ()=> toggleTimeFilter("month"),
  //               child: Container(
  //                 decoration: isMonthSelected?Styles.selctedContainerDecoration:null,
  //                 child:  Center(
  //                   child: Text("This Month" , style: TextStyle(color: isMonthSelected?ThemeColors.secondaryBackground: ThemeColors.textColor)),)),
  //             ),),

  //           ],
  //         ),
  //       );
  // }
}