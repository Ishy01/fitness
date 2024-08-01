class UserModel {
  final String uid;
  final String? email;
  final String? firstName;
  final String? lastName;
  String? gender;
  String? dateOfBirth;
  String? weight;
  String? height;
  String? profilePictureUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.dateOfBirth,
    this.weight,
    this.height,
    this.profilePictureUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'weight': weight,
      'height': height,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      gender: map['gender'],
      dateOfBirth: map['dateOfBirth'],
      weight: map['weight'],
      height: map['height'],
      profilePictureUrl: map['profilePictureUrl'],
    );
  }
}
