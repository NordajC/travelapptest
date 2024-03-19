import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelapptest/authentication_repository.dart';
import 'package:travelapptest/user/user_model.dart';

//delete here
import 'dart:typed_data';
import 'package:flutter/foundation.dart'
    show kIsWeb; // To determine if the current platform is web

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //save user data to firestore
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  //fetch user data from firestore
  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();

      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  //update user data in firestore
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _db
          .collection("Users")
          .doc(updatedUser.id)
          .set(updatedUser.toJson());
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  //update single field in user data
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update(json);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  //remove data
  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  //upload image
  // Future<String> uploadImage(String path, XFile image) async{
  //   try{
  //     //referencing the path of an image using a unique name in firebase storage
  //     final ref = FirebaseStorage.instance.ref(path).child(image.name);
  //     //uploads an image file to a specified location in your Firebase Cloud Storage
  //     await ref.putFile(File(image.path));

  //     //get url of uploaded image from firebase storage
  //     final url = await ref.getDownloadURL();
  //     return url;
  //   }
  //   catch(e){
  //     throw 'Something went wrong. Please try again.';
  //   }
  // }

  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);

      // Determine the MIME type based on the file extension
      String mimeType = _determineMimeType(image.name);

      // Set metadata to include the content type
      final metadata = SettableMetadata(contentType: mimeType);

      if (kIsWeb) {
        // On web, use putData to upload the file using its bytes and include metadata
        Uint8List? fileBytes = await image.readAsBytes();
        await ref.putData(fileBytes, metadata);
      } else {
        // On non-web platforms, continue using putFile and include metadata
        await ref.putFile(File(image.path), metadata);
      }

      // Get URL of uploaded image from Firebase Storage
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  // Helper function to determine the MIME type based on the file extension
  String _determineMimeType(String fileName) {
    String extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      // Add more cases for other image types as needed
      default:
        return 'application/octet-stream'; // Use a generic binary stream type or throw an error
    }
  }
}
