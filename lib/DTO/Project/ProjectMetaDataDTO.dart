class ProjectMetaDataDTO {
  String metaDataId;
  String metaDataName;
  bool isRequired;
  String value;

  ProjectMetaDataDTO(this.metaDataId, this.metaDataName, this.isRequired, this.value);

  Map<String, dynamic> toJson() {
    return {
      'metaDataId': metaDataId,
      'metaDataName': metaDataName,
      'isRequired': isRequired,
      'value': value,
    };
  }

  factory ProjectMetaDataDTO.fromJson(Map<String, dynamic> json) {
    return ProjectMetaDataDTO(
      json['metaDataId'] ?? '',
      json['metaDataName'] ?? '',
      json['isRequired'] ?? '',
      json['value'] ?? '',
    );
  }
}
