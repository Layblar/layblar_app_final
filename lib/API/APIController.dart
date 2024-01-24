import 'package:ass/DTO/Device/DeviceCategoryDTO.dart';
import 'package:ass/DTO/Device/DeviceDTO.dart';
import 'package:ass/DTO/Household/HouseholdDTO.dart';
import 'package:ass/DTO/Label/LabelDataDTO.dart';
import 'package:ass/DTO/Project/ProjectDTO.dart';
import 'package:ass/DTO/Project/ProjectMetaDataDTO.dart';
import 'package:ass/DTO/SmartMeter/SmartMeterDataDTO.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class APIController{

   static const String baseUrl = 'http://35.219.229.135';
   static const headers = <String, String>{
        'Content-Type': 'application/json',
  };

    static Future<String?> getTokenFromSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');
      return token;
    } catch (e) {
      debugPrint('Error getting token from SharedPreferences: $e');
      return null;
    }
  }

    static Future<void> saveTokenToSharedPreferences(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('jwt_token', token);
  }

  


  //POST method, register a new household
  static Future<bool> registerHousehold(String password, String email, String firstname, String lastname )async{

    const apiUrl = '$baseUrl/auth/register/householduser';
    final Map <String, dynamic> postData = {
    'password' : password,
    'email': email,
    'firstname': firstname,
    'lastname': lastname,
  };

  final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(postData),
    );
    if(response.statusCode == 201){
      debugPrint(response.body);
      return true;
    }else{
      return false;
    }
  
  }


//POST method after a household is registered, user has to log in in order to get a jwt token
 static Future<int> login(String email, String password)async{
  const apiUrl = '$baseUrl/auth/login';
    final Map <String, dynamic> postData = {
    'email': email,
    'password' : password,
  };

  final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(postData),
    );

    if(response.statusCode == 200){

      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = responseData['token'];


      await saveTokenToSharedPreferences(token);
    }
    return response.statusCode;

  }



  


  //GET method to get the household information, required householdID from JWT token
  static Future<HouseholdDTO?>getHousehold(String token, String householdId)async{

      //final String? token = await getTokenFromSharedPreferences();
     
        final  String id = householdId;
        final apiUrl = '$baseUrl/household/$id';
        final response = await http.get(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }
        );
        if (response.statusCode == 200) {
          debugPrint("[--household]" + response.body);
          Map<String,dynamic> householdJson = jsonDecode(response.body);
          HouseholdDTO householdDTO = HouseholdDTO.fromJson(householdJson);
          return householdDTO;
        } else {
          return null;
        }     
  }
  

  //GET method to list all devices, requires householdID from JWT token

  static Future<List<DeviceDTO>>getHouseHoldDevices(String token, String householdId)async{

      final String? token = await getTokenFromSharedPreferences();

      
        final  String id = householdId;
        final apiUrl = '$baseUrl/household/$id/device';

        final response = await http.get(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }
        );

        if (response.statusCode == 200) {
          List<DeviceDTO> alldevices = [];
          List<dynamic> allDevicesJson = jsonDecode(response.body);

          for(var d in allDevicesJson){
            DeviceDTO deviceDTO = DeviceDTO.fromJson(d);
            alldevices.add(deviceDTO);
          }
          return alldevices;
        } else {
          return [];
        }      
  }

  static Future<List<DeviceCategoryDTO>> getAllDeviceCategories(String token)async{
    const  apiUrl = '$baseUrl/deviceLibrary/category';
    final response = await http.get(
      Uri.parse(apiUrl),
       headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
        },
    );

     debugPrint("status" + response.statusCode.toString());

    if (response.statusCode == 200) {
          List<DeviceCategoryDTO> categories = [];
          List<dynamic> allCategoriesJson = jsonDecode(response.body);
          debugPrint("deviceCategories" + response.body);
          for(var c in allCategoriesJson){
            DeviceCategoryDTO category = DeviceCategoryDTO.fromJson(c);
            categories.add(category);
          }
          return categories;
        } else {
          return [];
        }      
  }

  //POST add device to househld, requires hh id
  static Future<int> addDevice(String token, String householdId, String deviceName, List<DeviceCategoryDTO> categories)async{
    
    final String id = householdId;
    final  apiUrl = '$baseUrl/household/$id/device';

    final Map<String, dynamic> requestBody = {
    'deviceName': deviceName,
    'categories': categories.map((category) => category.toJson()).toList(),
  };
    final response = await http.post(
      Uri.parse(apiUrl),
       headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        body: jsonEncode(requestBody),

    );

    debugPrint(response.statusCode.toString());
    return response.statusCode;
  }

  //remove device
  static Future<void> removeDevice(String token, String householdId, String deviceId)async{
    final String id = householdId;
    final String device = deviceId;
    final apiUrl = '$baseUrl/household/$id/device/$device';

    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
    );
    debugPrint(response.statusCode.toString());

  }

  //update device




//GET for smart meter data, requires household id
static Future<List<SmartMeterDataDTO>> getSmartMeterData(String token, String householdId, String from, String to)async {
  final  String id = householdId;
  final apiUrl = '$baseUrl/smartmeter/household/$id';
  final Map<String, dynamic> queryParams = {};
  queryParams['from'] = from;
  queryParams['to'] = to;

  final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);




  final response = await http.get(
    uri,
    headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
    );


    if (response.statusCode == 200) {
      
      List<SmartMeterDataDTO> smartMeterData = [];
      List<dynamic> smartMeterDataJson = jsonDecode(response.body);

      for(var s in smartMeterDataJson){
        SmartMeterDataDTO smartMeterDataDTO = SmartMeterDataDTO.fromJson(s);
        smartMeterData.add(smartMeterDataDTO);
      }
      return smartMeterData;
    } else {
      return [];
    }      
}

//Get for all Projects
static Future<List<ProjectDTO>>getAllProjects(String token, {
  String? householdId,
  bool? isJoinable,
  String? researcherId,
})async{
  const apiUrl = '$baseUrl/project/project';
  final Map<String, dynamic> queryParams = {};

  if (householdId != null) {
    queryParams['householdId'] = householdId;
  }

  if (isJoinable != null) {
    queryParams['isJoinable'] = isJoinable.toString();
  }

  if (researcherId != null) {
    queryParams['researcherId'] = researcherId;
  }

  // Füge die Query-Parameter zur URI hinzu
  final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);


  final response = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
      }
    );

    if (response.statusCode == 200) {
      List<ProjectDTO> allProjects = [];
      List<dynamic> jsonProjects = jsonDecode(response.body);
      debugPrint(response.body);
      for (var p in jsonProjects){
        ProjectDTO project = ProjectDTO.fromJson(p);
        allProjects.add(project);
      }
      
      return allProjects;
    } else {
      return [];
    }      
  }

//Get for a speific project
static Future<String> getAProject(String token, String projectId)async {

  final String id = projectId;
  final apiUrl = '$baseUrl/project/project/$id';

  final response = await http.get(
    Uri.parse(apiUrl),
      headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
      }
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "Error";
    }      
  }


//POST join a project
static Future<int> joinProject(String token, String householdId, String projectId, List<DeviceDTO> devices, List<ProjectMetaDataDTO> metadata)async{
  final String id = householdId;
  final String project = projectId;

  final String apiUrl = '$baseUrl/project/project/$project/household/$id/';

  final Map <String, dynamic> postData = {
    'householdId': id,
    'metaData' : metadata.map((device) => device.toJson()).toList(),
    'devices' :  devices.map((meta) => meta.toJson()).toList(),
    
  };

   final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
      },
      body: jsonEncode(postData),
    );

    debugPrint(response.statusCode.toString());
    return response.statusCode;

}



////////////////////////////LABELS//////////////////////////////

//get call for labeled Data
 static Future<List<LabeledDataDTO>> getLabeledData(String token, String householdId)async{
    final String id = householdId;
    final apiUrl = '$baseUrl/label/$id';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      }
    );

      if (response.statusCode == 200) {


        debugPrint("[------getlabeledData----]" + response.statusCode.toString());
        final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
        return parsed
          .map<LabeledDataDTO>((json) => LabeledDataDTO.fromJson(json))
          .toList();
      } else {
        return [];
      }      
  }

  //Post add new label
  static Future<int> addLabeledData(String token, String householdId, DeviceDTO device, List<SmartMeterDataDTO> smartMeterData)async{
    final id = householdId;
    const apiUrl = '$baseUrl/label';
    final Map <String, dynamic> postData = {
      'householdId': id,
      'device' : device.toJson(),
      'smartMeterData' :  smartMeterData.map((smd) => smd.toJson()).toList()  
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
      },
      body: jsonEncode(postData),
    );

    return response.statusCode;

  }


  //Update labeled Data

  static Future<void> updateLabaledData(String token, String labeledDataId, DeviceDTO device, List<SmartMeterDataDTO> smartMeterData)async{

    final String id = labeledDataId;
    final apiUrl = '$baseUrl/label/$id';

    final Map <String, dynamic> postData = {
      'labeledDataId': id,
      'deviceDTO' : device.toJson(),
      'smartMeterData' :  smartMeterData.map((smd) => smd.toJson()).toList()  
    };

     final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },      
      body: jsonEncode(postData),
    );

    debugPrint(response.statusCode.toString());
  }

  //delete labeledData
  static Future<void> deleteLabeledData(String token, String labeledDataId)async{
    final String id = labeledDataId;
    final String apiUrl = '$baseUrl/label/$id';

    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
        debugPrint(response.body);
      } else {
        debugPrint ("Error");
      }      
  }

  static Future<int> registerSmartMeter(String token, String householdId, String smartMeterId)async{
    
    final String id = householdId;
    final String apiUrl = '$baseUrl/household/$id/smartMeterReader';

    final Map <String, dynamic> postData = {
      'smartMeterId': smartMeterId,
    };

     final response = await http.post(
      Uri.parse(apiUrl),
       headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
      },
      body: jsonEncode(postData),
    );

    debugPrint(response.statusCode.toString());
    return response.statusCode;
  }


 


  static bool isReponseValid(int statusCode){

    if(statusCode == 200){
      return true;
    }else if(statusCode == 401){
      return false;
    }
    return false;
  }







  
















}


