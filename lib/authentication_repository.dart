import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travelapptest/home_screen.dart';
import 'package:travelapptest/login/login_screen.dart';
import 'package:travelapptest/login/user_controller.dart';
import 'package:travelapptest/onboarding_screen.dart';
import 'package:travelapptest/signup/sucess_screen.dart';
import 'package:travelapptest/signup/verify_email.dart';
import 'package:travelapptest/trip/trip_controller.dart';
import 'firebase_options.dart';
import 'package:travelapptest/login/login.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  //get user data
  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  screenRedirect() async {
    final user = _auth.currentUser;

    if (user != null) {
      //if email verified send to home/navigation menu
      if (user.emailVerified) {
        Get.offAll(() => HomePage(), binding: TripBinding());
      } else {
        Get.offAll(() => VerifyEmailScreen(email: _auth.currentUser?.email));
      }
    } else {
      //if user is null send to login screen

      //debugging purposes
      if (kDebugMode) {
        print("================ GetStorage ================");
        print(deviceStorage.read('isFirstTime'));
      }

      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() => LoginScreen())
          : Get.offAll(OnboardingScreen());
    }
  }

  //register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
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
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
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

  //login with email and password
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
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

  //sign in with google

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      // get details from the request
      final GoogleSignInAuthentication? googleAuth =
          await userAccount?.authentication;

      // Create credentials

      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // pass the credentials to Firebase
      return await _auth.signInWithCredential(credentials);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (kDebugMode) {
        print("FirebaseAuthException caught: ${e.code}, Message: ${e.message}");
      }
      String errorMessage = _handleFirebaseAuthError(e.code);
      throw Exception(
          errorMessage); // Wrap the error message in an Exception for consistent error handling
    } catch (e) {
      // Handle any other errors
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // reset/forget password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
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
