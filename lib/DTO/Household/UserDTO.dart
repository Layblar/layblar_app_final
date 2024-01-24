class UserDTO {
  String userId;
  String researcherId;
  String email;
  String householdId;
  List<String> roles;

  UserDTO({
    required this.userId,
    required this.researcherId,
    required this.email,
    required this.householdId,
    required this.roles,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      userId: json['userId'],
      researcherId: json['researcherId'],
      email: json['email'],
      householdId: json['householdId'],
      roles: List<String>.from(json['roles']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'researcherId': researcherId,
      'email': email,
      'householdId': householdId,
      'roles': roles,
    };
  }
}