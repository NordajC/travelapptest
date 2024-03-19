
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:travelapptest/authentication_repository.dart';
import 'package:travelapptest/login/reset_password.dart';
import 'package:travelapptest/pop_up_loaders/full_screen_loader.dart';
import 'package:travelapptest/signup/network_manager.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  //send reset password link to email
  sendPasswordResetEmail() async{
    try{
      FullScreenLoader.openLoadingDialog("Processing your request...", "assets/loading_animation.json");

      //check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        FullScreenLoader.stopLoading();
        return;
      }

      //validate form
      if(!forgetPasswordFormKey.currentState!.validate()){
        FullScreenLoader.stopLoading();
        return;
      }

      //send email link to reset password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      //remove loader
      FullScreenLoader.stopLoading();

      //show success message
      Get.snackbar(
        'Email Sent', // Title
        'A link has been sent to your email to reset your password.', // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.to(() => ResetPasswordScreen(email: email.text.trim()));


    }catch(e){
      //
      Get.snackbar(
        'Error', // Title
        e.toString(), // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

    resendPasswordResetEmail(String email) async{
    try{
      FullScreenLoader.openLoadingDialog("Processing your request...", "assets/loading_animation.json");

      //check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        FullScreenLoader.stopLoading();
        return;
      }

      //send email link to reset password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      //remove loader
      FullScreenLoader.stopLoading();

      //show success message
      Get.snackbar(
        'Email Sent', // Title
        'A link has been sent to your email to reset your password.', // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.to(() => ResetPasswordScreen(email: email));

    }catch(e){
      //
      
    }
  }

}
