import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelapptest/login_screen.dart';
import 'package:travelapptest/onboarding_screen.dart';
import 'firebase_options.dart';


class AuthenticationRepository extends GetxController{

  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  screenRedirect() async{

    if(kDebugMode){
      print("================ GetStorage ================");
      print(deviceStorage.read('isFirstTime'));
    }

    deviceStorage.writeIfNull('isFirstTime', true);
    deviceStorage.read('isFirstTime') != true ? Get.offAll(() =>  LoginScreen()) : Get.offAll( OnboardingScreen());
  }

}