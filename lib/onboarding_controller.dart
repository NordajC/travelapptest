import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelapptest/login_screen.dart';

class onBoardingController extends GetxController {
  static onBoardingController get instance => Get.find();
  
  //variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  //update the current page index when page scrolled
  void updatePageIndicator(index) => currentPageIndex.value = index;

  void dotNavigationClick(index){
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }

  void nextPage(){
    if(currentPageIndex.value == 2){
      final storage = GetStorage();

      if(kDebugMode){
      print("================ GetStorage ================");
      print(storage.read('isFirstTime'));
    }

      storage.write('isFirstTime', false);  
      Get.offAll(const LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  void skipPage(){
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }
}