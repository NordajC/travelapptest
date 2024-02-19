import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:travelapptest/pop_up_loaders/animation_loader.dart';

class FullScreenLoader {
  
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false, // User must tap button to close dialog
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              
              AnimationLoaderWidget(text: text, animation: animation),
            ],
          ),
        )
      )
    );
  }

  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop(); // Close the dialog
  }
}
