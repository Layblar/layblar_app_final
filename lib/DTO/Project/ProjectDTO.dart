import 'package:ass/DTO/Label/LabelDTO.dart';
import 'package:ass/DTO/Project/ProjectMetaDataDTO.dart';

class ProjectDTO {
  String projectId;
  String projectName;
  String projectDescription;
  String projectDataUseDeclaration;
  String startDate; 
  String endDate; 
  String created; 
  List<ProjectMetaDataDTO> metaData;
  List<LabelDTO> labels;

  ProjectDTO({
    required this.projectId,
    required this.projectName,
    required this.projectDescription,
    required this.projectDataUseDeclaration,
    required this.startDate,
    required this.endDate,
    required this.created,
    required this.metaData,
    required this.labels,
  });

  factory ProjectDTO.fromJson(Map<String, dynamic> json) {
    List<dynamic> metaDataList = json['metaData'] ?? [];
    List<ProjectMetaDataDTO> parsedMetaData =
        metaDataList.map((metaData) => ProjectMetaDataDTO.fromJson(metaData)).toList();

    List<dynamic> labelsList = json['labels'] ?? [];
    List<LabelDTO> parsedLabels = labelsList.map((label) => LabelDTO.fromJson(label)).toList();

    return ProjectDTO(
      projectId: json['projectId'] ?? '',
      projectName: json['projectName'] ?? '',
      projectDescription: json['projectDescription'] ?? '',
      projectDataUseDeclaration: json['projectDataUseDeclaration'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      created: json['created'] ?? '',
      metaData: parsedMetaData,
      labels: parsedLabels,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'projectName': projectName,
      'projectDescription': projectDescription,
      'projectDataUseDeclaration': projectDataUseDeclaration,
      'startDate': startDate,
      'endDate': endDate,
      'created': created,
      'metaData': metaData.map((metaData) => metaData.toJson()).toList(),
      'labels': labels.map((label) => label.toJson()).toList(),
    };
  }
}