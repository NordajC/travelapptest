import 'package:flutter/material.dart';
import 'package:travelapptest/authentication_repository.dart';
import 'package:travelapptest/login/user_controller.dart';
import 'package:get/get.dart';
import 'package:travelapptest/profile.dart';

// Define a class for menu items to hold data
class CustomDrawerItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  CustomDrawerItem(
      {required this.title, required this.icon, required this.onTap});
}

// Custom Drawer Widget
class CustomDrawer extends StatelessWidget {
  final List<CustomDrawerItem> drawerItems;

  const CustomDrawer({super.key, required this.drawerItems});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    final logoutController = Get.put(AuthenticationRepository());
    return Drawer(
      child: ListView(
        // padding: const EdgeInsets.all(24.0),
        children: <Widget>[
          Obx(() => DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, // Or any other color
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25, // Adjust the size to your needs
                      backgroundImage:
                          NetworkImage(controller.user.value.profilePicture),
                      backgroundColor: Colors.white,
                      onBackgroundImageError: (exception, stackTrace) {
                        // Handle errors when the profile picture fails to load
                      },
                      child: controller.user.value.profilePicture.isEmpty
                          ? Text(
                              controller.user.value.fullName[0].toUpperCase(),
                              style: TextStyle(
                                  fontSize: 25)) // Adjust the style as needed
                          : null,
                    ),
                    SizedBox(width: 16), // Space between the picture and text
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.user.value.fullName,
                            style: TextStyle(
                              color: Colors
                                  .white, // Adjust text color to match your theme
                              fontSize: 20, // Adjust font size to your needs
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            controller.user.value.email,
                            style: TextStyle(
                              color: Colors
                                  .white70, // Adjust text color to match your theme
                              fontSize: 16, // Adjust font size to your needs
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              // Settings tap action
              Navigator.pop(context);
              Get.to(() => const ProfileScreen());
              
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.logout),
          //   title: Text('Log Out'),
          //   onTap: () {
          //     // Log out tap action
          //     () async {
          //       try {
          //         await logoutController.logout();
          //       } catch (e) {
          //         // Handle the error, such as showing a Snackbar with the error message
          //         final scaffold = ScaffoldMessenger.of(context);
          //         scaffold.showSnackBar(
          //           SnackBar(
          //             content: Text(e.toString()),
          //             action: SnackBarAction(
          //                 label: 'DISMISS',
          //                 onPressed: scaffold.hideCurrentSnackBar),
          //           ),
          //         );
          //       }
          //     };
          //   },
          // ),
        ]..addAll(drawerItems
            .map((item) => ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.title),
                  onTap: item.onTap,
                ))
            .toList()),
      ),
    );
  }
}
