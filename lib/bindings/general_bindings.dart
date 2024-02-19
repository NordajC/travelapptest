import 'package:get/get.dart';
import 'package:travelapptest/signup/network_manager.dart';

class GeneralBindings extends Bindings {
  
  @override
  void dependencies() {
    Get.put(NetworkManager());
  }
}