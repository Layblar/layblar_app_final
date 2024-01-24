import 'package:ass/DTO/Device/DeviceCategoryDTO.dart';

class HouseholdDeviceDTO{

  String deviceId;
  String deviceName;
  String deviceDescription;
  String manufacturer;
  String modelNumber;
  int powerDraw;
  String energyEfficiencyRating;
  double weight;
  List<DeviceCategoryDTO> categories;

  HouseholdDeviceDTO({
    required this.deviceId,
    required this.deviceName,
    required this.deviceDescription,
    required this.manufacturer,
    required this.modelNumber,
    required this.powerDraw,
    required this.energyEfficiencyRating,
    required this.weight,
    required this.categories,
  });


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


  factory HouseholdDeviceDTO.fromJson(Map<String, dynamic> json) {
    List<dynamic> categoriesList = json['categories'] ?? [];
    List<DeviceCategoryDTO> parsedCategories =
        categoriesList.map((category) => DeviceCategoryDTO.fromJson(category)).toList();

    return HouseholdDeviceDTO(
      deviceId: json['deviceId'] ?? '',
      deviceName: json['deviceName'] ?? '',
      deviceDescription: json['deviceDescription'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      modelNumber: json['modelNumber'] ?? '',
      powerDraw: json['powerDraw'] ?? 0,
      energyEfficiencyRating: json['energyEfficiencyRating'] ?? '',
      weight: json['weight'] ?? 0.0,
      categories: parsedCategories,
    );
  }



  
}