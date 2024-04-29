import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelapptest/authentication_repository.dart';
import 'package:travelapptest/design/custom_drawer.dart';
import 'package:travelapptest/home/home_appbar.dart';
import 'package:travelapptest/login/user_controller.dart';
import 'package:travelapptest/trip/create_trip_form.dart';
import 'package:travelapptest/trip/edit_trip_form.dart';
import 'package:travelapptest/trip/trip_controller.dart';
import 'package:travelapptest/trip/trip_itinerary/itinerary_controller.dart';
import 'package:travelapptest/trip/trip_itinerary/itinerary_page.dart';
import 'package:travelapptest/trip/trip_model.dart';
import 'package:travelapptest/trip/trip_page.dart';
import 'package:travelapptest/trip/trip_repository.dart';
import 'package:travelapptest/trip/trip_model.dart';

class HomePage extends StatelessWidget {

  
  onInit() {
    final TripController tripController = Get.find();
    final UserController userController = Get.find();
    tripController.loadUserTrips();
    tripController.loadBudgetsForUserTrips(userController.user.value.id);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthenticationRepository());

    final TripController tripController = Get.find();
    tripController.loadUserTrips();

    return Scaffold(
      appBar: HomeAppBar(),
      endDrawer: CustomDrawer(
        drawerItems: [
          CustomDrawerItem(
            title: "Settings",
            icon: Icons.settings,
            onTap: () {
              //  navigation to settings
            },
          ),
          CustomDrawerItem(
            title: "Log Out",
            icon: Icons.logout,
            onTap: () async {
              try {
                await controller.logout();
              } catch (e) {
                // Handle the error
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
      body: Obx(() {
        // React to changes in the trip list.
        if (tripController.trips.isEmpty) {
          return Center(child: Text('No trips found.'));
        }
        return ListView.builder(
          itemCount: tripController.trips.length,
          itemBuilder: (context, index) {
            final trip = tripController.trips[index];
            return GestureDetector(
              onTap: () {
                print('Trip selected: ${trip.destination}');

                Get.to(() => ItineraryPage(tripId: trip.id),
                    binding: ItineraryBinding(), arguments: trip.id);

                print("tripid: " + trip.id);
              },
              child: TravelCard(
                tripId: trip.id,
                tripName: trip.destination,
                tripStartDate: DateFormat('yyyy-MM-dd').format(trip.startDate),
                tripEndDate: DateFormat('yyyy-MM-dd').format(trip.endDate),
                tripBudget: trip.participantBudgets
                    .firstWhere(
                        (budget) => budget.participantId == trip.creatorId,
                        orElse: () =>
                            ParticipantBudget(participantId: '', budget: 0))
                    .budget,
                tripSpent: 0, 
                // tripImageUrl: trip.imageUrl, // If you have images for trips
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement action to add more trips
          Get.to(() => CreateTripForm(), binding: TripBinding());
        },
        tooltip: 'Add Trip',
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF5E6EFF),
      ),
    );
  }
}

class TravelCard extends StatelessWidget {
  final String tripName;
  final String tripStartDate;
  final String tripEndDate;
  final double tripBudget; 
  final double tripSpent; 
  final String tripImageUrl;
  final String tripId;

  const TravelCard({
    super.key,
    required this.tripName,
    required this.tripStartDate,
    required this.tripEndDate,
    required this.tripBudget,
    required this.tripSpent,
    required this.tripId,
    this.tripImageUrl = '', 
  });

  String formatTripDates(DateTime startDate, DateTime endDate) {
    if (startDate.year == endDate.year) {
      if (startDate.month == endDate.month) {
        // Same month and year
        return '${DateFormat('MMM d').format(startDate)} - ${DateFormat('d, yyyy').format(endDate)}';
      }
      // Same year, different months
      return '${DateFormat('MMM d').format(startDate)} - ${DateFormat('MMM d, yyyy').format(endDate)}';
    } else {
      // Different years
      return '${DateFormat('MMM d, yyyy').format(startDate)} - ${DateFormat('MMM d, yyyy').format(endDate)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final TripController tripController = Get.find();

    var budgetInfo = tripController.userTripBudgets[tripId];

    double spentPercentage =
        ((budgetInfo?.spendings ?? 0) / (budgetInfo?.budget ?? 1))
            .clamp(0.0, 1.0);
    bool isOverBudget = spentPercentage >= 1.0;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(32, 32, 32, 16),
      child: Container(
        height: 230,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 0),
            ),
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
                  // Image placeholder
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
                        child: Image.network(
                          tripImageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    */
                  ),
                  // Popup menu
                  Positioned(
                    top: 10,
                    right: 10,
                    child: PopupMenuButton<String>(
                      onSelected: (String result) {
                        // Handle your action selection here
                        if (result == 'Edit') {
                          // Implement the edit action
                          print("edit " + tripId);
                          Get.to(() => EditTripForm(tripId: tripId));
                        } else if (result == 'Delete') {
                          // Implement the delete action
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text('Delete Trip'),
                                  content: Text(
                                      'Are you sure you want to delete this trip?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Implement the delete action
                                        Navigator.of(context).pop();
                                        print("delete " + tripId);
                                        tripController.deleteTrip(tripId);
                                      },
                                      child: Text('Delete'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ));
                            },
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          tripName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        formatTripDates(DateTime.parse(tripStartDate),
                            DateTime.parse(tripEndDate)),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4), 

                  // Budget progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: spentPercentage,
                      minHeight: 10,
                      backgroundColor: Colors.grey[300],
                      color: spentPercentage < 0.75
                        ? Colors.blue
                        : spentPercentage < 0.9
                          ? Colors.yellow
                          : Colors.red, // Change color based on spending percentage
                    ),
                  ),
                  SizedBox(height: 8), 
                  Row(
                    children: [
                      Text(
                        'Spent: £${budgetInfo?.spendings} / £${tripBudget.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isOverBudget ? Colors.red : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 8), 
                      if (isOverBudget == true)
                        Row(
                          children: [
                            Icon(Icons.warning_rounded, color: Colors.red, size: 18,),
                            SizedBox(width: 4), 
                            Text(
                              'Overbudget',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                    ],
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
