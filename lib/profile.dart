import 'package:flutter/material.dart';
import 'package:travelapptest/edit%20profile/change_name.dart';
import 'package:travelapptest/home/appbar.dart';
import 'package:travelapptest/login/user_controller.dart';
import 'package:get/get.dart';
import 'package:travelapptest/app.dart';
import 'package:travelapptest/design/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Profile',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF313131),
            )),
        actions: [],
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      // final networkImage = controller.user.value.profilePicture;
                      // final image = networkImage.isNotEmpty ? networkImage : 
                      return CircleAvatar(
                        radius: 50, // Adjust the size to your needs
                        backgroundImage:
                            NetworkImage(controller.user.value.profilePicture),
                        backgroundColor: Colors.white,
                        onBackgroundImageError: (exception, stackTrace) {
                          print("Failed to load the profile picture: $exception");
                        },
                        child: controller.user.value.profilePicture.isEmpty
                            ? Text(
                                controller.user.value.fullName[0].toUpperCase(),
                                style: TextStyle(
                                    fontSize: 50)) // Adjust the style as needed
                            : null,
                      );
                    }),
                    TextButton(
                        onPressed: () => controller.uploadUserProfilePicture(),
                        child: Text('Change Profile Picture')),
                  ],
                ),
              ),

              SizedBox(height: 24),

              Divider(),

              SizedBox(height: 16),

              const Text("Profile Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left),

              SizedBox(height: 16),

              ProfileMenu(
                theme: theme,
                title: 'Name',
                value: controller.user.value.fullName,
                onPressed: () => Get.to(() => ChangeName()),
              ),

              SizedBox(height: 16),

              ProfileMenu(
                theme: theme,
                title: 'Username',
                value: controller.user.value.username,
                onPressed: () {},
              ),

              SizedBox(height: 16),

              Divider(),

              SizedBox(height: 16),

              const Text("Personal Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left),

              SizedBox(height: 16),

              ProfileMenu(
                theme: theme,
                title: 'User ID',
                value: controller.user.value.id,
                onPressed: () {},
                icon: Icons.copy,
              ),

              SizedBox(height: 16),

              ProfileMenu(
                theme: theme,
                title: 'Email',
                value: controller.user.value.email,
                onPressed: () {},
              ),

              SizedBox(height: 16),

              ProfileMenu(
                theme: theme,
                title: 'Phone',
                value: controller.user.value.phoneNumber,
                onPressed: () {},
              ),

              SizedBox(height: 16),

              Divider(),

              SizedBox(height: 16),

              // Center(
              //   child: TextButton(
              //     child: Text('Delete Account', style: TextStyle(color: Colors.red, fontSize: 16),),
              //     onPressed: () {

              //     }
              //   ),
              // )
            ],
          ),
        ),
        //user details
      ),
    );
  }
}
