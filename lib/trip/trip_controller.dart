import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelapptest/login/user_controller.dart';
import 'package:travelapptest/trip/trip_model.dart';
import 'package:travelapptest/trip/trip_repository.dart';
import 'package:travelapptest/user/user_model.dart';
import 'package:travelapptest/user/user_repository.dart';

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
  final UserRepository userRepository = Get.find();

  final destination = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final budget = TextEditingController();
  final description = TextEditingController();

  GlobalKey<FormState> tripFormKey = GlobalKey<FormState>();

  var trips = <TravelPlanModel>[].obs;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var userNames = <String, RxnString>{}.obs;

  var userTripBudgets = Map<String, ParticipantBudget>().obs;

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
        loadBudgetsForUserTrips(userController.user.value.id);
      }
    });
  }

  Future<void> createTrip() async {
    String creatorId = userController.user.value.id;
    double creatorBudgetValue = double.tryParse(budget.text) ?? 0.0;
    String destinationValue = destination.text;
    DateTime startDateValue = DateTime.parse(startDate.text);
    DateTime endDateValue = DateTime.parse(endDate.text);
    String descriptionValue = description.text;

    // Create a new ID if it's a new trip or use an existing ID
    String tripId = _db.collection('Trips').doc().id;

    List<DailyItinerary> dailyItineraries = List.generate(
      endDateValue.difference(startDateValue).inDays + 1,
      (index) => DailyItinerary(
        date: startDateValue.add(Duration(days: index)),
        items: [],
      ),
    );

    TravelPlanModel newTrip = TravelPlanModel(
      id: tripId,
      creatorId: creatorId,
      destination: destinationValue,
      startDate: startDateValue,
      endDate: endDateValue,
      participantIds: [creatorId],
      participantBudgets: [
        ParticipantBudget(participantId: creatorId, budget: creatorBudgetValue)
      ],
      description: descriptionValue,
      dailyItineraries: dailyItineraries,
    );

    try {
      await tripRepository.saveTripRecord(newTrip);
      // Save each daily itinerary as a separate document in the sub-collection
      for (DailyItinerary itinerary in dailyItineraries) {
        await tripRepository.saveDailyItinerary(tripId, itinerary);
      }

      trips.add(newTrip);
      trips.refresh();
      loadUserTrips();
      Get.back();
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

  // void onEditSubmit(String tripId) {
  //   TravelPlanModel updatedTrip = TravelPlanModel(
  //     id: tripId, // Make sure to have this ID from the trip you're editing
  //     creatorId: userController.user.value.id,
  //     destination: destination.text,
  //     startDate: DateTime.parse(startDate.text),
  //     endDate: DateTime.parse(endDate.text),
  //     participantIds: [
  //       userController.user.value.id
  //     ], // Depending on your model, adjust as necessary
  //     participantBudgets: [
  //       ParticipantBudget(
  //           participantId: userController.user.value.id,
  //           budget: double.parse(budget.text))
  //     ],
  //     description: description.text,
  //   );

  //   updateTrip(updatedTrip);
  // }

  void onEditSubmit(String tripId) async {
    TravelPlanModel originalTrip = await fetchTripById(tripId);

    DateTime newStartDate = DateTime.parse(startDate.text);
    DateTime newEndDate = DateTime.parse(endDate.text);

    if (newStartDate.isAfter(newEndDate)) {
      Get.snackbar("Error", "Start date cannot be after end date",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    bool datesChanged = newStartDate != originalTrip.startDate ||
        newEndDate != originalTrip.endDate;

    if (datesChanged) {
      bool userConfirmed = await showConfirmationDialog();
      if (!userConfirmed) {
        return; // Stop if user cancels the operation
      }

      // Generate updated itineraries
      List<DailyItinerary> updatedDailyItineraries = List.generate(
        newEndDate.difference(newStartDate).inDays + 1,
        (index) => DailyItinerary(
          date: newStartDate.add(Duration(days: index)),
          items: originalTrip.dailyItineraries
              .firstWhere(
                  (itin) =>
                      itin.date.toIso8601String() ==
                      newStartDate.add(Duration(days: index)).toIso8601String(),
                  orElse: () => DailyItinerary(
                      date: newStartDate.add(Duration(days: index)), items: []))
              .items,
        ),
      );

      // Update itineraries in Firestore
      await tripRepository.updateItineraries(
          tripId, updatedDailyItineraries, originalTrip.dailyItineraries);

      // Update the trip with new dates and possibly other modified fields
      originalTrip.startDate = newStartDate;
      originalTrip.endDate = newEndDate;
      originalTrip.dailyItineraries = updatedDailyItineraries;
      updateTrip(originalTrip);
    }
  }

  Future<bool> showConfirmationDialog() async {
    bool? result = await Get.dialog<bool>(AlertDialog(
      title: Text("Confirm Changes"),
      content: Text(
          "Changing dates will modify the itinerary. Shortening the trip will result in deleting the itenraries of the missing days. Do you wish to continue?"),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false), // User cancels the action
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Get.back(result: true), // User confirms the action
          child: Text("Continue"),
        ),
      ],
    ));

    // If the dialog is dismissed by tapping outside of it (result is null), treat it as a cancellation.
    return result ?? false;
  }

  Future<void> updateTrip(TravelPlanModel updatedTrip) async {
    try {
      await tripRepository.saveTripRecord(updatedTrip);
      int index = trips.indexWhere((trip) => trip.id == updatedTrip.id);
      if (index != -1) {
        trips[index] = updatedTrip;
        trips.refresh(); // To ensure the UI reflects the updated data
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

  // In your TripController:

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

  //fetch user names by id

  void fetchAndStoreUserName(String userId) async {
    if (!userNames.containsKey(userId)) { // If username is not already fetched
      userNames[userId] = RxnString();
      try {
        UserModel user = await UserRepository().fetchUserById(userId);
        userNames[userId]!.value = user.username;
      } catch (e) {
        print("Error fetching user: $e");
        userNames[userId]!.value = "Unknown"; // Set a default value in case of an error
      }
    }
  }

  // Method to get the username for a given userId
  // Get the username for the given userId
  String? getUserName(String userId) {
    if (userNames.containsKey(userId)) {
      return userNames[userId]?.value;
    }
    return null;
  }


    

  // method to get total budget, debts and spendings for a trip

  Future <void> loadBudgetsForUserTrips(String userId) async {
    var tripsSnapshot = await FirebaseFirestore.instance.collection('Trips').get();
    for (var tripDoc in tripsSnapshot.docs) {
      String tripId = tripDoc.id;
      List participantBudgets = tripDoc.data()['participantBudgets'];
      var participantBudget = participantBudgets.firstWhere(
        (budget) => budget['participantId'] == userId,
        orElse: () => null
      );

      if (participantBudget != null) {
        double spendings = participantBudget['spendings'] ?? 0;
        Map<String, dynamic> debts = participantBudget['debts'] as Map<String, dynamic> ?? {};
        // Sum up all debts for this user
        double totalDebts = debts.values.fold(0.0, (sum, debt) => sum + (debt ?? 0.0));

        // Update spendings to include debts
        spendings += totalDebts;

        userTripBudgets[tripId] = ParticipantBudget(
          participantId: participantBudget['participantId'],
          budget: participantBudget['budget'],
          spendings: spendings
        );
      }
    }
  }
  

  // remove this method from the controller if needed
Future<void> fetchParticipantBudget(String tripId, String currentUserId) async {
  // Mark the function body as asynchronous with the 'async' keyword
  try {
    ParticipantBudget currentParticipantBudget = await tripRepository.fetchBudgetForParticipant(tripId, currentUserId);
    // Use the fetched participant budget here
    print(currentParticipantBudget);
  } catch (e) {
    // Handle any potential errors here
    print('Error fetching participant budget: $e');
  }
}

}

