import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelapptest/authentication_repository.dart';
import 'package:travelapptest/signup/sucess_screen.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  //send email verification
  sendEmailVerification() async{
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      Get.snackbar(
        'Email Verification', // Title
        'A verification email has been sent to your email address. Please verify your email to continue.', // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }catch(e){
      Get.snackbar(
        'Error! Please wait for 1 minute before trying again.', // Title
        e.toString(), // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  //redirect
  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async{
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(() => SucessScreen(title: 'Email Verified', subtitle: "Your email has been successfully verified!", onPressed: ()=> AuthenticationRepository.instance.screenRedirect(), buttonText: 'Continue'));
      }
    });
  } 


  //manual check
  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(() => SucessScreen(title: 'Email Verified', subtitle: "Your email has been successfully verified!", onPressed: ()=> AuthenticationRepository.instance.screenRedirect(), buttonText: 'Continue'));
    }
  }
}



