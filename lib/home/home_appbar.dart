
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelapptest/home/appbar.dart';
import 'package:travelapptest/login/user_controller.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget{
  const HomeAppBar({super.key,});
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return CustomAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            // Text('Plan Your Next Trip', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFF313131)),),
            // Obx(() => Text(controller.user.value.fullName, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Color(0xFF313131)))),
            Text('NexTrip', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFF313131)),),
          ],
        ),
      actions: [],
    );
  }

    @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}