class SmartMeterDTO{
  
  String smartMeterId;

  SmartMeterDTO({
    required this.smartMeterId,
  });

   factory SmartMeterDTO.fromJson(Map<String, dynamic> json) {
    return SmartMeterDTO(
      smartMeterId: json['smartMeterId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'smartMeterId': smartMeterId,
    };
  }
}