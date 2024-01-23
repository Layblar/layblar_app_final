import 'package:ass/DTO/Device/DeviceCategoryDTO.dart';

class LabelDTO{

  String labelId;
  String labelName;
  String labelDescription;
  String labelMethod;
  List<DeviceCategoryDTO> categories;

  LabelDTO({
    required this.labelId,
    required this.labelName,
    required this.labelDescription,
    required this.labelMethod,
    required this.categories
  });


  factory LabelDTO.fromJson(Map<String, dynamic> json) {
    List<dynamic> categoriesList = json['categories'] ?? [];
    List<DeviceCategoryDTO> parsedCategories =
        categoriesList.map((category) => DeviceCategoryDTO.fromJson(category)).toList();

    return LabelDTO(
      labelId: json['labelId'] ?? '',
      labelName: json['labelName'] ?? '',
      labelDescription: json['labelDescription'] ?? '',
      labelMethod: json['labelMethod'] ?? '',
      categories: parsedCategories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'labelId': labelId,
      'labelName': labelName,
      'labelDescription': labelDescription,
      'labelMethod': labelMethod,
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }




}