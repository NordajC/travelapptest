import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:travelapptest/authentication_repository.dart';
import 'package:travelapptest/pop_up_loaders/full_screen_loader.dart';
import 'package:travelapptest/signup/network_manager.dart';
import 'package:travelapptest/signup/verify_email.dart';
import 'package:travelapptest/user/user_model.dart';
import 'package:travelapptest/user/user_repository.dart';

class SignupController extends GetxController {

  static SignupController get instance => Get.find();

  //variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final firstName = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();
  final username = TextEditingController();

  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  void signup() async {
    try {
      //start loading
      FullScreenLoader.openLoadingDialog("We are processing your information...", "assets/loading_animation.json");

      //check if there is internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        FullScreenLoader.stopLoading();
        return;
      }

      //validate inputs
      if(!signupFormKey.currentState!.validate()){
        FullScreenLoader.stopLoading();
        Get.snackbar(
          'Invalid Input', // Title
          'Please correct the errors in the form.', // Message
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if(!privacyPolicy.value){
        FullScreenLoader.stopLoading();
        Get.snackbar(
          'Accept the terms and conditions.', // Corrected: Direct string for the title
          'Please accept the terms and conditions to create an account.', // Corrected: Direct string for the message
          snackPosition: SnackPosition.BOTTOM, // Position of the Snackbar
          backgroundColor: Colors.orange, // Background color of the Snackbar
          shouldIconPulse: true, // Make the Snack bar icon pulse
          isDismissible: true, // Snack bar is dismissible
          colorText: Colors.white, // Text color
          icon: Icon(Icons.warning, color: Colors.white), // Icon to show on the Snackbar
          duration: Duration(seconds: 3), // Duration that the Snackbar will be shown
        );
        return;
      }

      //register user
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      //save authenticated user details onto firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        username: username.text.trim(),
        profilePicture: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      //remove loader
      FullScreenLoader.stopLoading();

      //success message snack bar
      Get.snackbar(
        'Account has been created.', // Corrected: Direct string for the title
        'Please verify your email to continue.', // Corrected: Direct string for the message
        snackPosition: SnackPosition.BOTTOM, // Position of the Snackbar
        backgroundColor: Colors.green, // Background color of the Snackbar
        shouldIconPulse: true, // Make the Snack bar icon pulse
        isDismissible: true, // Snack bar is dismissible
        colorText: Colors.white, // Text color
        icon: Icon(Icons.warning, color: Colors.white), // Icon to show on the Snackbar
        duration: Duration(seconds: 3), // Duration that the Snackbar will be shown
      );

      //move to verify email
      Get.to(()=> VerifyEmailScreen(email: email.text.trim(),));
    }
    catch (e) {
      Get.snackbar(
        'Error', // Title
        'Failed to create account: $e', // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    // finally {
    //   FullScreenLoader.stopLoading();
    // }
  }
}