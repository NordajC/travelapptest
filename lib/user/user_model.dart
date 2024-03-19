import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  String firstName;
  String lastName;
  final String email;
  final String phoneNumber;
  String username;
  String profilePicture;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.username,
    required this.profilePicture,
  });

  // //helper to get full name
  String get fullName => '$firstName $lastName';

  // //helper to get formatted phone number
  // String get formattedPhoneNumber => phoneNumber;

  // //helper to get generate username

  static List<String> nameParts(fullName) => fullName.split(" ");

  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : '';

    String camelCaseUsername = "$firstName$lastName";
    String usernameWithPrefix = "cwt_$camelCaseUsername";
    return usernameWithPrefix;
  }

  static UserModel empty() => UserModel(
        id: '',
        firstName: '',
        lastName: '',
        email: '',
        phoneNumber: '',
        username: '',
        profilePicture: '',
      );

  //convert user model to json
  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'username': username,
        'profilePicture': profilePicture,
      };

  //factory to convert firestore document to user model
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    if (document.data() != null) {
      return UserModel(
        id: document.id,
        firstName: document['firstName'] ?? '',
        lastName: document['lastName'] ?? '',
        email: document['email'] ?? '',
        phoneNumber: document['phoneNumber'] ?? '',
        username: document['username'] ?? '',
        profilePicture: document['profilePicture'] ?? '',
      );
    } else {
      return UserModel.empty();
    }
  }
}

