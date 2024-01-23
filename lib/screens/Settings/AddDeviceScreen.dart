import 'package:ass/API/APIController.dart';
import 'package:ass/DTO/Device/DeviceCategoryDTO.dart';
import 'package:ass/DTO/Device/DeviceDTO.dart';
import 'package:ass/HelperClasses/StatusCodes.dart';
import 'package:ass/Services/TokenCheckService.dart';
import 'package:ass/Themes/Styles.dart';
import 'package:ass/Themes/ThemeColors.dart';
import 'package:ass/WIdgets/BottomToast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}


//mocked DeviceDTO

DeviceDTO mockedDevice = DeviceDTO("123", "richis mikrowelle", "irgendson ding", "miele", "123123123", 12, "B", 512, [DeviceCategoryDTO("123", "test", "test description")]);

//required: 
//devicename
//categories


//optinal
//devicedesc
//manufacturer
//modelno
//pwerdraw in
//energyefficencyrating
//weight: double


class _AddDeviceScreenState extends State<AddDeviceScreen> {

  var deviceNameController = TextEditingController();
  var deviceDescriptionController = TextEditingController();
  var manufacturerController = TextEditingController();
  var modelNUmberController = TextEditingController();
  var powerDrawController = TextEditingController();
  var energyEfficiencyRatingController = TextEditingController();
  var weightController = TextEditingController();
  List<DeviceCategoryDTO> categories = [];
    //String selectedCategories = "";
  Set<DeviceCategoryDTO> selectedCategories = <DeviceCategoryDTO>{};

  Future<List<DeviceCategoryDTO>>? deviceCategories;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deviceCategories = getAllDeviceCategories();

  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child:  Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColors.secondaryBackground,
        ),
        backgroundColor: ThemeColors.primaryBackground,
        body: getFormSection(),
       
          floatingActionButton: FloatingActionButton(onPressed: ()=> addNewDevice(),child: const Center(child: Text("+")),),
        ),
        
      );
    
  }

  Container getFormSection() {
    return Container(
        width: double.infinity,
        decoration: Styles.containerDecoration,
        margin: const EdgeInsets.all(8),

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
          
                  children: [
                    Text("Add device", style: Styles.headerTextStyle,),
                    Text("Fieldsmarked with * are required.", style: Styles.regularTextStyle),
                    const SizedBox(height: 16),
                    Container(
                      decoration: Styles.primaryBackgroundContainerDecoration,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField( 
                          style: Styles.regularTextStyle,
                          controller: deviceNameController,
                          decoration:  InputDecoration(
                            hoverColor: ThemeColors.primary,
                            labelText: ("Device Name *"),
                            labelStyle: Styles.regularTextStyle,
                            
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                const SizedBox(height: 16), 
                Container(
                  decoration: Styles.primaryBackgroundContainerDecoration,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField( 
                      style: Styles.regularTextStyle,
                      controller: deviceDescriptionController,
                      decoration:  InputDecoration(
                        hoverColor: ThemeColors.primary,
                        labelText: ("Description"),
                        labelStyle: Styles.regularTextStyle,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16), 
                Container(
                  decoration: Styles.primaryBackgroundContainerDecoration,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField( 
                      style: Styles.regularTextStyle,
                      controller: manufacturerController,
                      decoration:  InputDecoration(
                        hoverColor: ThemeColors.primary,
                        labelText: ("Manufacturer"),
                        labelStyle: Styles.regularTextStyle,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16), 
                Container(
                  decoration: Styles.primaryBackgroundContainerDecoration,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField( 
                      style: Styles.regularTextStyle,
                      controller: modelNUmberController,
                      decoration:  InputDecoration(
                        hoverColor: ThemeColors.primary,
                        labelText: ("Model Number"),
                        labelStyle: Styles.regularTextStyle,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16), //
                Container(
                  decoration: Styles.primaryBackgroundContainerDecoration,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField( 
                      style: Styles.regularTextStyle,
                      controller: powerDrawController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true), // Allow decimal input
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}$')), // Allow digits and optional decimal point with up to 2 decimal places
                      ],
                      decoration:  InputDecoration(
                        hoverColor: ThemeColors.primary,
                        labelText: ("Power Draw"),                          
                        labelStyle: Styles.regularTextStyle,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16), 
                Container(
                  decoration: Styles.primaryBackgroundContainerDecoration,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField( 
                      style: Styles.regularTextStyle,
                      controller: energyEfficiencyRatingController,
                      decoration:  InputDecoration(
                        hoverColor: ThemeColors.primary,
                        labelText: ("Energy Efficiency Rating"),
                        labelStyle: Styles.regularTextStyle,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Hier wird der Abstand hinzugefügt
                //TODO: CATEGORIES
               // selectedCategories != '' ?Text(selectedCategories): const SizedBox(),
                //Text(selectedCategories),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                  child: Text("Choose at least one Category!", style: Styles.infoBoxTextStyle,),
                ),
                
                FutureBuilder(
                  future: deviceCategories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: SizedBox(height: 32, width: 32, child: CircularProgressIndicator()));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text("No Categories.", style: Styles.regularTextStyle);
                    } else {
                      List<DeviceCategoryDTO> categories = snapshot.data!;

                      return Column(
                        children: categories.map((category) {
                          return Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.white
                            ),
                            child: CheckboxListTile(
                              title: Text(category.categoryName, style: Styles.regularTextStyle,),
                              value: selectedCategories.contains(category),
                              activeColor: ThemeColors.primary,
                              tileColor: Colors.transparent,
                              onChanged: (value) {
                                setState(() {
                                  if (value != null && value) {
                                    selectedCategories.add(category);
                                  } else {
                                    selectedCategories.remove(category);
                                  }
                                  debugPrint(selectedCategories.length.toString());
                                });
                              },
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),

               
              ]
            ),
        ),
      );
  }


  


  //TODO: proper arsing and selecting the right new device;
  Future<List<DeviceCategoryDTO>> getAllDeviceCategories()async{


    String? token = await APIController.getTokenFromSharedPreferences();
    if(token != null){
        if(JwtDecoder.isExpired(token)){
          TokenCheckService.navigateBackIfTokenIsExpired(context);
        }else{
          List<DeviceCategoryDTO> allCategories = await APIController.getAllDeviceCategories(token);
          return allCategories;
        }
    }
    return [];
  }

  DeviceDTO createNewDeviceDTO(List<DeviceCategoryDTO>categories){

    String deviceName = deviceNameController.text;
    String deviceDescription = deviceDescriptionController.text;
    String manufacturer = manufacturerController.text;
    String modelno = modelNUmberController.text;
    int powerDraw = 0;
    if(powerDrawController.text.isNotEmpty){
         powerDraw =  int.parse(powerDrawController.text);
    }
    String energyEfficencyRating = energyEfficiencyRatingController.text;
    //double weight = double.parse(weightController.text);
    List<DeviceCategoryDTO> categories = [];
      
    return DeviceDTO("", deviceName, deviceDescription, manufacturer, modelno, powerDraw, energyEfficencyRating, 0.0, categories);
    
  }

  Future<void>addNewDevice()async{

    String deviceName = deviceNameController.text.trim();

    if (deviceName.isEmpty || selectedCategories.isEmpty) {
      BottomToast.showToast("Device name and Categories cannot be empty!");
      return;
    }

    //DeviceDTO newDeviceDTO = createNewDeviceDTO(selectedCategories.toList());
    

    String? token = await APIController.getTokenFromSharedPreferences();
    if(token != null){
        if(JwtDecoder.isExpired(token)){
          TokenCheckService.navigateBackIfTokenIsExpired(context);
        }else{
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          String householdId = decodedToken['householdId'];
          int response = await APIController.addDevice(token, householdId, deviceName, selectedCategories.toList());

         


          if(response == StatusCodes.OK){
             resetPage();
             BottomToast.showToast("New Device successfully added!");
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

  void resetPage(){
    setState(() {
      selectedCategories.clear();
      deviceNameController.text = "";
      deviceDescriptionController.text = "";
      manufacturerController.text = "";
      modelNUmberController.text = "";
      powerDrawController.text = "";
      energyEfficiencyRatingController.text = "";
    });
  }
}