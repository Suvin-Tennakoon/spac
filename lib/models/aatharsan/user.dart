class UserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? uid;

  //Receiving Data
  UserModel(
      {this.firstName, this.lastName, this.email, this.password, this.uid});

  factory UserModel.fromMap(map) {
    return UserModel(
        firstName: map['firstName'],
        lastName: map['lastName'],
        email: map['email'],
        password: map['password'],
        uid: map['uid']);
  }

  //Sending Data
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'uid': uid
    };
  }
}
