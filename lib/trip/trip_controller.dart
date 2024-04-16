// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:travelapptest/login/user_controller.dart';
// import 'package:travelapptest/trip/trip_model.dart'; // Adjust the import path as needed
// import 'package:travelapptest/trip/trip_repository.dart'; // Ensure this points to your TripRepository

// class TripController extends GetxController {
//   static TripController get instance => Get.find();

//   final TripRepository tripRepository = Get.put(TripRepository());
//   final UserController userController = Get.find<UserController>();

//   final destination = TextEditingController();
//   final startDate = TextEditingController();
//   final endDate = TextEditingController();
//   final budget = TextEditingController();
//   final description = TextEditingController();

//   GlobalKey<FormState> tripFormKey = GlobalKey<FormState>();

//   RxList<TravelPlanModel> trips = RxList<TravelPlanModel>();

//   @override
//   void onInit() {
//     super.onInit();
//     loadUserTrips();
//   }

//   // Method to create a new trip using input from a form
//   Future<void> createTrip() async {
//     String creatorId = userController.user.value.id;

//     // Use the .text property of each TextEditingController to access the form field values
//     String destinationValue = destination.text;
//     DateTime startDateValue = DateTime.parse(
//         startDate.text); // Ensure this parsing aligns with your date format
//     DateTime endDateValue = DateTime.parse(endDate.text); // Same as above
//     double budgetValue =
//         double.tryParse(budget.text) ?? 0.0; // Provide a fallback value
//     String descriptionValue = description.text;

//     TravelPlanModel newTrip = TravelPlanModel(
//       id: '',
//       creatorId: creatorId,
//       destination: destinationValue,
//       startDate: startDateValue,
//       endDate: endDateValue,
//       participantIds: [creatorId],
//       participantBudgets: [
//         ParticipantBudget(participantId: creatorId, budget: budgetValue)
//       ],
//       description: descriptionValue,
//     );

//     try {
//       await tripRepository.saveTripRecord(newTrip);
//       trips.add(
//           newTrip); // Optionally, update the observable list for UI binding
//       Get.back(); // Go back to the previous screen after creation
//       Get.snackbar("Success", "Trip created successfully",
//           backgroundColor: Colors.green, colorText: Colors.white);
//     } catch (e) {
//       Get.snackbar("Error", "Failed to create trip: $e",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     }
//   }

//   // Fetch trips for the current user
//   void loadUserTrips() async {
//     String userId = userController.user.value.id;

//     try {
//       final userTrips = await tripRepository.fetchUserTrips(userId);
//       trips.assignAll(userTrips);
//     } catch (e) {
//       Get.snackbar("Error", "Failed to load trips: $e",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     }
//   }

//   // Method to delete a trip
//   Future<void> deleteTrip(String tripId) async {
//     try {
//       await tripRepository.deleteTripRecord(tripId);
//       trips.removeWhere(
//           (trip) => trip.id == tripId); // Update the observable list
//       Get.snackbar("Success", "Trip deleted successfully",
//           backgroundColor: Colors.green, colorText: Colors.white);
//     } catch (e) {
//       Get.snackbar("Error", "Failed to delete trip: $e",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     }
//   }

//   // Additional methods for updating trips, managing participants, etc., can be added here...
// }

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelapptest/login/user_controller.dart';
import 'package:travelapptest/trip/trip_model.dart';
import 'package:travelapptest/trip/trip_repository.dart';

// class TripBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<TripRepository>(() => TripRepository()); // This ensures TripRepository is registered
//     Get.lazyPut<UserController>(() => UserController(), fenix: true); // fenix ensures UserController is only created if it is not already available.
//     Get.lazyPut<TripController>(() => TripController(tripRepository: Get.find(), userController: Get.find()));
//   }
// }

class TripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TripRepository());
    Get.lazyPut<UserController>(() => UserController(), fenix: true);
    Get.lazyPut(() =>
        TripController(tripRepository: Get.find(), userController: Get.find()));
  }
}

class TripController extends GetxController {
  static TripController get instance => Get.find();
  final TripRepository tripRepository;
  final UserController userController;

  final destination = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final budget = TextEditingController();
  final description = TextEditingController();

  GlobalKey<FormState> tripFormKey = GlobalKey<FormState>();

  var trips = <TravelPlanModel>[].obs;

  TripController({
    required this.tripRepository,
    required this.userController,
  });

  @override
  void onInit() {
    super.onInit();
    // Watch the user Rx object for changes and load trips when the user data is set
    ever(userController.user, (_) {
      if (userController.user.value.id.isNotEmpty) {
        loadUserTrips();
      }
    });
  }

  Future<void> createTrip() async {
    String creatorId = userController.user.value.id;
    // Assuming the budget text field in the form collects the budget for the trip creator
    double creatorBudgetValue = double.tryParse(budget.text) ?? 0.0;

    // Use the .text property of each TextEditingController to access the form field values
    String destinationValue = destination.text;
    DateTime startDateValue = DateTime.parse(
        startDate.text); // Make sure this matches your date format
    DateTime endDateValue = DateTime.parse(endDate.text);
    String descriptionValue = description.text;

    TravelPlanModel newTrip = TravelPlanModel(
      id: '', // Empty for Firestore to auto-generate an ID
      creatorId: creatorId,
      destination: destinationValue,
      startDate: startDateValue,
      endDate: endDateValue,
      participantIds: [
        creatorId
      ], // Initially, only the creator is a participant
      participantBudgets: [
        ParticipantBudget(participantId: creatorId, budget: creatorBudgetValue)
      ], // Setting the budget for the creator
      description: descriptionValue,
    );

    try {
      await tripRepository.saveTripRecord(newTrip);
      trips.add(newTrip); // Add the new trip to the observable list
      Get.back(); // Navigate back to the previous screen
      Get.snackbar("Success", "Trip created successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to create trip: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void loadUserTrips() async {
    String userId = userController.user.value.id;

    try {
      final userTrips = await tripRepository.fetchUserTrips(userId);
      trips.assignAll(userTrips);
      print('Loading trips for user: $userId');
    } catch (e) {
      trips.clear(); //clear list if there is an error
      Get.snackbar("Error", "Failed to load trips: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> deleteTrip(String tripId) async {
    try {
      await tripRepository.deleteTripRecord(tripId);
      trips.removeWhere((trip) => trip.id == tripId);
      update(); //update the observable list
      Get.snackbar("Success", "Trip deleted successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to delete trip: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void onEditSubmit(String tripId) {
    TravelPlanModel updatedTrip = TravelPlanModel(
      id: tripId, // Make sure to have this ID from the trip you're editing
      creatorId: userController.user.value.id,
      destination: destination.text,
      startDate: DateTime.parse(startDate.text),
      endDate: DateTime.parse(endDate.text),
      participantIds: [
        userController.user.value.id
      ], // Depending on your model, adjust as necessary
      participantBudgets: [
        ParticipantBudget(
            participantId: userController.user.value.id,
            budget: double.parse(budget.text))
      ],
      description: description.text,
    );

    updateTrip(updatedTrip);
  }

  Future<void> updateTrip(TravelPlanModel updatedTrip) async {
    try {
      await tripRepository.saveTripRecord(updatedTrip);
      int index = trips.indexWhere((trip) => trip.id == updatedTrip.id);
      if (index != -1) {
        trips[index] = updatedTrip;
        trips.refresh();
      }
      Get.back(); // Close the edit screen
      Get.snackbar("Success", "Trip updated successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to update trip: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  //fetch trip data by id
  Future<TravelPlanModel> fetchTripById(String tripId) async {
    try {
      return await tripRepository.fetchTripById(tripId);
    } catch (e) {
      print('Failed to fetch trip in controller: $e');
      Get.snackbar('Error', 'Failed to fetch trip details');
      throw Exception('Failed to fetch trip in controller: $e');
    }
  }
}
