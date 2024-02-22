import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelapptest/home_screen.dart';
import 'package:travelapptest/login/login_screen.dart';
import 'package:travelapptest/onboarding_screen.dart';
import 'package:travelapptest/signup/sucess_screen.dart';
import 'package:travelapptest/signup/verify_email.dart';
import 'firebase_options.dart';
import 'package:travelapptest/login/login.dart';


class AuthenticationRepository extends GetxController{

  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  screenRedirect() async{
    final user = _auth.currentUser;

    if(user != null){
      //if email verified send to home/navigation menu
      if(user.emailVerified){
        Get.offAll(() => HomePage());
      }else{
        Get.offAll(() => VerifyEmailScreen(email: _auth.currentUser?.email));
      }
    }else{
      //if user is null send to login screen

      //debugging purposes
      if(kDebugMode){
        print("================ GetStorage ================");
        print(deviceStorage.read('isFirstTime'));
      }

      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true ? Get.offAll(() =>  LoginScreen()) : Get.offAll( OnboardingScreen());
      }
  }


  //register with email and password
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (kDebugMode) {
        print("FirebaseAuthException caught: ${e.code}");
      }
      String errorMessage = _handleFirebaseAuthError(e.code);
      throw errorMessage;
    } catch (e) {
      // Handle any other errors
      throw 'An unexpected error occurred. Please try again.';
    }

  }

  String _handleFirebaseAuthError(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  //verify email
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (kDebugMode) {
        print("FirebaseAuthException caught: ${e.code}");
      }
      String errorMessage = _handleFirebaseAuthError(e.code);
      throw errorMessage;
    } catch (e) {
      // Handle any other errors
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  //logout
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    }on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (kDebugMode) {
        print("FirebaseAuthException caught: ${e.code}");
      }
      String errorMessage = _handleFirebaseAuthError(e.code);
      throw errorMessage;
    } catch (e) {
      // Handle any other errors
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  //login with email and password
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (kDebugMode) {
        print("FirebaseAuthException caught: ${e.code}");
      }
      String errorMessage = _handleFirebaseAuthError(e.code);
      throw errorMessage;
    } catch (e) {
      // Handle any other errors
      throw 'An unexpected error occurred. Please try again.';
    }
  }

}