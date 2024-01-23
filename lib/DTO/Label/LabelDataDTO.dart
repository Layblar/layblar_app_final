import 'package:ass/DTO/Device/DeviceDTO.dart';
import 'package:ass/DTO/SmartMeter/SmartMeterDataDTO.dart';

class LabeledDataDTO {
  String labeledDataId;
  String householdId;
  DeviceDTO device;
  List<SmartMeterDataDTO> smartMeterData;
  String createdAt;

  LabeledDataDTO({
    required this.labeledDataId,
    required this.householdId,
    required this.device,
    required this.smartMeterData,
    required this.createdAt,
  });

  factory LabeledDataDTO.fromJson(Map<String, dynamic> json) {
    return LabeledDataDTO(
      labeledDataId: json['labeledDataId'],
      householdId: json['householdId'],
      device: DeviceDTO.fromJson(json['device']),
      smartMeterData: (json['smartMeterData'] as List)
          .map((dataJson) => SmartMeterDataDTO.fromJson(dataJson))
          .toList(),
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'labeledDataId': labeledDataId,
      'householdId': householdId,
      'device': device.toJson(),
      'smartMeterData': smartMeterData.map((data) => data.toJson()).toList(),
      'createdAt': createdAt,
    };
  }
}
