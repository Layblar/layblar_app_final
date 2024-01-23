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

// Factory method to create a HouseholdUserDTO instance from a JSON map
  factory HouseholdUserDTO.fromJson(Map<String, dynamic> json) {
    return HouseholdUserDTO(
      userId: json['userId'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  // Convert the object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
