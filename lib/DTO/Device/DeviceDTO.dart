import 'package:ass/DTO/Device/DeviceCategoryDTO.dart';

class DeviceDTO{

  String deviceId;
  String deviceName;
  String deviceDescription;
  String manufacturer;
  String modelNumber;
  int powerDraw;
  String energyEfficiencyRating;
  double weight;
  List<DeviceCategoryDTO> categories;

  DeviceDTO(this.deviceId, this.deviceName, this.deviceDescription, this.manufacturer, this.modelNumber, this.powerDraw, this.energyEfficiencyRating, this.weight, this.categories);


   // Convert DeviceDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceDescription': deviceDescription,
      'manufacturer': manufacturer,
      'modelNumber': modelNumber,
      'powerDraw': powerDraw,
      'energyEfficiencyRating': energyEfficiencyRating,
      'weight': weight,
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }

  // Create a DeviceDTO from JSON
  factory DeviceDTO.fromJson(Map<String, dynamic> json) {
    return DeviceDTO(
      json['deviceId'],
      json['deviceName'],
      json['deviceDescription'],
      json['manufacturer'],
      json['modelNumber'],
      json['powerDraw'],
      json['energyEfficiencyRating'],
      json['weight'],
      (json['categories'] as List<dynamic>).map((category) => DeviceCategoryDTO.fromJson(category)).toList(),
    );
  }
}