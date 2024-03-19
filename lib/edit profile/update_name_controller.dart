import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelapptest/login/user_controller.dart';
import 'package:travelapptest/pop_up_loaders/full_screen_loader.dart';
import 'package:travelapptest/profile.dart';
import 'package:travelapptest/signup/network_manager.dart';
import 'package:travelapptest/user/user_repository.dart';

class UpdateNameController extends GetxController {

  static UpdateNameController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }
  
  Future<void> initializeNames() async {
    firstName.text = userController.user.value.firstName;
    lastName.text = userController.user.value.lastName;
  }

  Future<void> updateUserName() async {
    try {
      //loading
      FullScreenLoader.openLoadingDialog('Updating your details...', "assets/loading_animation.json");

      //check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        FullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if(!updateUserNameFormKey.currentState!.validate()){
        FullScreenLoader.stopLoading();
        return;
      }

      //update user data by mapping name into json
      Map<String, dynamic> name = {
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
      };
      
      //update user data in firestore
      await userRepository.updateSingleField(name);

      //update Rx user data
      userController.user.value.firstName = firstName.text.trim();
      userController.user.value.lastName = lastName.text.trim();

      //remove loader
      FullScreenLoader.stopLoading();

      //show snackbar
      Get.snackbar(
        'Success', // Title
        'Your name has been updated successfully.', // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      //move to prev screen
      Get.off(()=> const ProfileScreen());
    }
    catch(e){
      FullScreenLoader.stopLoading();
      Get.snackbar(
        'Error', // Title
        e.toString(), // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

}