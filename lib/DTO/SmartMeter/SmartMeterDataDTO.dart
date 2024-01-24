class SmartMeterDataDTO {
  String time;
  String sensorId;
  double value1_7_0;
  double value1_8_0;
  double value2_7_0;
  double value2_8_0;
  double value3_8_0;
  double value4_8_0;
  double value16_7_0;
  double value31_7_0;
  double value32_7_0;
  double value51_7_0;
  double value52_7_0;
  double value71_7_0;
  double value72_7_0;

  SmartMeterDataDTO(
    this.time,
    this.sensorId,
    this.value1_7_0,
    this.value1_8_0,
    this.value2_7_0,
    this.value2_8_0,
    this.value3_8_0,
    this.value4_8_0,
    this.value16_7_0,
    this.value31_7_0,
    this.value32_7_0,
    this.value51_7_0,
    this.value52_7_0,
    this.value71_7_0,
    this.value72_7_0,
  );

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'sensorId': sensorId,
      '1.7.0': value1_7_0,
      '1.8.0': value1_8_0,
      '2.7.0': value2_7_0,
      '2.8.0': value2_8_0,
      '3.8.0': value3_8_0,
      '4.8.0': value4_8_0,
      '16.7.0': value16_7_0,
      '31.7.0': value31_7_0,
      '32.7.0': value32_7_0,
      '51.7.0': value51_7_0,
      '52.7.0': value52_7_0,
      '71.7.0': value71_7_0,
      '72.7.0': value72_7_0,
    };
  }

  factory SmartMeterDataDTO.fromJson(Map<String, dynamic> json) {
    return SmartMeterDataDTO(
      json['time'],
      json['sensorId'],
      json['1.7.0'],
      json['1.8.0'],
      json['2.7.0'],
      json['2.8.0'],
      json['3.8.0'],
      json['4.8.0'],
      json['16.7.0'],
      json['31.7.0'],
      json['32.7.0'],
      json['51.7.0'],
      json['52.7.0'],
      json['71.7.0'],
      json['72.7.0'],
    );
  }
}
