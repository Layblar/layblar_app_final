class DeviceCategoryDTO{

  String categoryId;
  String categoryName;
  String deviceCategoryDescription;

  DeviceCategoryDTO(this.categoryId, this.categoryName, this.deviceCategoryDescription);

  Map<String, dynamic> toJson() {
    return {
      'deviceCategoryId': categoryId,
      'deviceCategoryName': categoryName,
      'deviceCategoryDescription': deviceCategoryDescription
    };
  }

  factory DeviceCategoryDTO.fromJson(Map<String, dynamic> json) {
    return DeviceCategoryDTO(
      json['deviceCategoryId'] ?? '',
      json['deviceCategoryName'] ?? '',
      json['deviceCategoryDescription'] ?? ''
    );
  }

}