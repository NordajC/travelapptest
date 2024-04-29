import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelapptest/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:travelapptest/user/user_repository.dart';
import 'package:file_picker/file_picker.dart';



class UserController extends GetxController {
  static UserController get instance => Get.find();

  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    fetchUserRecords();
  }

  Future<void> fetchUserRecords() async {
    try {
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    }
  }

  Future<void> saveUserRecord(UserCredential? userCredential) async {
    try {
      //refresh user records
      await fetchUserRecords();

      if (user.value.id.isNotEmpty) {
        //get user data
        if (userCredential != null) {
          final nameParts =
              UserModel.nameParts(userCredential.user!.displayName ?? '');
          final username = UserModel.generateUsername(
              userCredential.user!.displayName ?? '');

          final user = UserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            username: username,
            firstName: nameParts[0],
            lastName:
                nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
            phoneNumber: userCredential.user!.phoneNumber ?? '',
            profilePicture: userCredential.user!.photoURL ?? '',
          );

          //save user data to firestore

          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error', // Title
        e.toString(), // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  uploadUserProfilePicture() async {
    XFile? image;

    // Adjusting for web: directly using bytes for upload if on the web
    final fileResult = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb, // Load the file data if on web
    );

    if (fileResult != null) {
      final pickedFile = fileResult.files.first;
      if (kIsWeb) {
        // For web, use the bytes to create an XFile
        if (pickedFile.bytes != null) {
          image = XFile.fromData(pickedFile.bytes!, name: pickedFile.name);
        }
      } else {
        // For non-web, continue using the path
        if (pickedFile.path != null) {
          image = XFile(pickedFile.path!);
        }
      }
    }

    if (image != null) {
      try {
        final imageUrl = await userRepository.uploadImage("Users/Images/Profile", image);

        // Update user image data
        Map<String, dynamic> json = {'profilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;

        Get.snackbar("Success", "Profile picture updated successfully.", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);

      } catch (e) {
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
