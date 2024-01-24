class HouseholdUserDTO {
  String userId;
  String email;
  String firstName;
  String lastName;

  HouseholdUserDTO({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
});

  factory HouseholdUserDTO.fromJson(Map<String, dynamic> json) {
    return HouseholdUserDTO(
      userId: json['userId'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
