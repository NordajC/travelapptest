import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelapptest/authentication_repository.dart';
import 'package:travelapptest/design/custom_drawer.dart';
import 'package:travelapptest/home/home_appbar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthenticationRepository());

    return Scaffold(
      appBar: HomeAppBar(),
      endDrawer: CustomDrawer(
        drawerItems: [
          CustomDrawerItem(
            title: "Settings",
            icon: Icons.settings,
            onTap: () {
              // Implement navigation to settings
            },
          ),
          CustomDrawerItem(
            title: "Log Out",
            icon: Icons.logout,
            onTap: () async {
              try {
                await controller.logout();
              } catch (e) {
                // Handle the error, such as showing a Snackbar with the error message
                final scaffold = ScaffoldMessenger.of(context);
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    action: SnackBarAction(
                        label: 'DISMISS',
                        onPressed: scaffold.hideCurrentSnackBar),
                  ),
                );
              }
            },
          ),
        ],
      ),
       body: ListView(
        children: [
          TravelCard(
            tripName: 'Paris, France',
            tripDate: 'April 10 - 15, 2023',
            tripPrice: 'Est. \$1200',
          ),
          // Add more TravelCard widgets as needed
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement action to add more trips
        },
        tooltip: 'Add Trip',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TravelCard extends StatelessWidget {
  final String tripName;
  final String tripDate;
  final String tripPrice;
  final String tripImageUrl;
  // Include additional fields if necessary, like an image path or a unique tag for Hero animations

  const TravelCard({
    super.key,
    required this.tripName,
    required this.tripDate,
    required this.tripPrice,
    this.tripImageUrl = '', // Change this later on to the actual image path
    // Additional parameters can be added here
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(32, 32, 32, 16),
      child: Container(
        height: 230,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Image and title row
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Colors.grey[300],
                    ),
                    child: Icon(Icons.image, size: 80, color: Colors.grey[600]),
                    // Uncomment the following lines when an image is available
                    /*
                    Hero(
                      tag: 'tripImageTag',
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.asset(
                          'path/to/trip/image',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    */
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: PopupMenuButton<String>(
                      onSelected: (String result) {
                        // Handle your action selection here
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text('Delete'),
                        ),
                      ],
                      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tripName,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Text(tripDate),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: AlignmentDirectional(0, 0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                      child: Text(
                        tripPrice,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
