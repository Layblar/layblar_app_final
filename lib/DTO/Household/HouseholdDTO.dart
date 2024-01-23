import 'package:ass/DTO/Household/HouseholdDeviceDTO.dart';
import 'package:ass/DTO/Household/HouseholdUserDTO.dart';
import 'package:ass/DTO/SmartMeter/SmartMeterDTO.dart';

class HouseholdDTO{
  String householdId;
  List<HouseholdUserDTO> users;
  List<HouseholdDeviceDTO> devices;
  List<SmartMeterDTO> smartmeters;


  HouseholdDTO({
    required this.householdId,
    required this.users,
    required this.devices,
    required this.smartmeters
  });


  factory HouseholdDTO.fromJson(Map<String, dynamic> json) {
    List<dynamic> userJsonList = json['users'];
    List<dynamic> deviceJsonList = json['devices'];
    List<dynamic> smartMeterJsonList = json['smartMeters'];

    List<HouseholdUserDTO> usersList =
        userJsonList.map((userJson) => HouseholdUserDTO.fromJson(userJson)).toList();
    List<HouseholdDeviceDTO> devicesList =
        deviceJsonList.map((deviceJson) => HouseholdDeviceDTO.fromJson(deviceJson)).toList();
    List<SmartMeterDTO> smartmetersList =
        smartMeterJsonList.map((smartMeterJson) => SmartMeterDTO.fromJson(smartMeterJson)).toList();

    return HouseholdDTO(
      householdId: json['householdId'],
      users: usersList,
      devices: devicesList,
      smartmeters: smartmetersList,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> usersJsonList = users.map((user) => user.toJson()).toList();
    List<Map<String, dynamic>> devicesJsonList = devices.map((device) => device.toJson()).toList();
    List<Map<String, dynamic>> smartmetersJsonList =
        smartmeters.map((smartmeter) => smartmeter.toJson()).toList();

    return {
      'householdId': householdId,
      'users': usersJsonList,
      'devices': devicesJsonList,
      'smartmeters': smartmetersJsonList,
    };
  }




}