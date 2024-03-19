import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelapptest/authentication_repository.dart';
import 'package:travelapptest/login/user_controller.dart';
import 'package:travelapptest/pop_up_loaders/full_screen_loader.dart';
import 'package:travelapptest/signup/network_manager.dart';

class LoginController extends GetxController{

  //variables
  final localStorage =GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final userController = Get.put(UserController());

  Future<void> emailAndPasswordSignIn() async {
    try{
      //loading
      FullScreenLoader.openLoadingDialog('Logging in', "assets/loading_animation.json");

      //check internet connection
      final isConnected = await NetworkManager.instance.isConnected();

      if(!isConnected){
        FullScreenLoader.stopLoading();
        return;
      }

      //validate form 
      if(!loginFormKey.currentState!.validate()){
        FullScreenLoader.stopLoading();
        // Get.snackbar(
        //   'Invalid Input', // Title
        //   'Please correct the errors in the form.', // Message
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        // );
        return;
      }

      //save data if selected remember me
      if(rememberMe.value){
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      final userCredentials = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      FullScreenLoader.stopLoading();

      AuthenticationRepository.instance.screenRedirect();


    }catch(e){
      //
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

  Future<void> googleSignIn() async {
    try{
      FullScreenLoader.openLoadingDialog('Logging in', "assets/loading_animation.json");

      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      //google auth
      final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();

      //save user data to firestore
      await userController.saveUserRecord(userCredentials);

      //remove loader
      FullScreenLoader.stopLoading();

      //redirect 
      AuthenticationRepository.instance.screenRedirect();

    }catch(e){
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