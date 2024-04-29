import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:travelapptest/trip/trip_model.dart'; // Adjust this import based on your file structure

class TripRepository extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Method to save or update a trip record
  Future<void> saveTripRecord(TravelPlanModel trip) async {
    DocumentReference tripRef;

    // Check if this is a new trip or an update to an existing one
    if (trip.id.isEmpty) {
      // New trip: Generate a new document ID
      tripRef = _db.collection("Trips").doc();
    } else {
      // Existing trip: Use the provided ID
      tripRef = _db.collection("Trips").doc(trip.id);
    }

    try {
      // Save or update the trip record using set with merge option
      await tripRef.set(trip.toJson(), SetOptions(merge: true));
    } catch (e) {
      // Error handling: throw an exception or handle it as you see fit
      throw Exception('Error saving trip: $e');
    }
  }

  //fetches all trips that contain the user as a participant
  Future<List<TravelPlanModel>> fetchUserTrips(String userId) async {
    try {
      // Query trips where the participantIds array contains the user ID
      final QuerySnapshot participantTripsSnapshot = await _db
          .collection("Trips")
          .where('participantIds', arrayContains: userId)
          .get();

      // Convert the query snapshot to a list of TravelPlanModel objects
      final allTrips = participantTripsSnapshot.docs
          .map((doc) => TravelPlanModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();

      // Return the list of trips
      return allTrips;
    } catch (e) {
      throw Exception('Error fetching user trips: $e');
    }
  }

  //delete a trip record
  Future<void> deleteTripRecord(String tripId) async {
    try {
      await _db.collection("Trips").doc(tripId).delete();
    } catch (e) {
      throw Exception('Error deleting trip: $e');
    }
  }

  //fetch trip by id
  Future<TravelPlanModel> fetchTripById(String tripId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _db.collection("Trips").doc(tripId).get();
      if (snapshot.exists) {
        return TravelPlanModel.fromSnapshot(snapshot);
      } else {
        throw Exception("Trip not found!");
      }
    } catch (e) {
      // Log the error, or handle it in a way that's appropriate for your app
      print('Error fetching trip: $e');
      throw Exception(
          'Error fetching trip: $e'); //  rethrow to handle it further up the call stack
    }
  }

  // Method to save or update a daily itinerary
  Future<void> saveDailyItinerary(
      String tripId, DailyItinerary itinerary) async {
    DocumentReference ref = _db
        .collection('Trips')
        .doc(tripId)
        .collection('DailyItineraries')
        .doc(itinerary.date.toIso8601String());
    await ref.set(itinerary.toJson(), SetOptions(merge: true));
  }

  // Method to fetch all itineraries for a trip
  Future<List<DailyItinerary>> fetchDailyItineraries(String tripId) async {
    QuerySnapshot snapshot = await _db
        .collection('Trips')
        .doc(tripId)
        .collection('DailyItineraries')
        .get();
    return snapshot.docs
        .map((doc) =>
            DailyItinerary.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Method to delete a daily itinerary
  Future<void> deleteDailyItinerary(String tripId, DateTime date) async {
    await _db
        .collection('Trips')
        .doc(tripId)
        .collection('DailyItineraries')
        .doc(date.toIso8601String())
        .delete();
  }

// Method to update itineraries in the repository
  Future<void> updateItineraries(
      String tripId,
      List<DailyItinerary> updatedItineraries,
      List<DailyItinerary> originalItineraries) async {
    // Create a map from the original itineraries for quick lookup
    Map<String, DailyItinerary> originalMap = {
      for (var itin in originalItineraries) itin.date.toIso8601String(): itin
    };

    // Set for fast checks on existence in the updated list
    Set<String> updatedDates = {
      for (var itin in updatedItineraries) itin.date.toIso8601String()
    };

    // Handle deletions for itineraries not present in the updated list
    for (var original in originalItineraries) {
      if (!updatedDates.contains(original.date.toIso8601String())) {
        await deleteDailyItinerary(tripId, original.date);
      }
    }

    // Handle additions or updates
    for (var updated in updatedItineraries) {
      await saveDailyItinerary(tripId, updated);
    }
  }

  // Fetch participant budgets based on tripId
  Future<List<ParticipantBudget>> fetchParticipantBudgets(String tripId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> tripSnapshot =
          await _db.collection("Trips").doc(tripId).get();
      var data = tripSnapshot.data();

      if (data == null) {
        throw Exception("Trip not found");
      }

      List<dynamic> budgetsData = data['participantBudgets'] ?? [];
      List<ParticipantBudget> budgets = budgetsData
          .map((budget) =>
              ParticipantBudget.fromJson(budget as Map<String, dynamic>))
          .toList();

      return budgets;
    } catch (e) {
      print('Failed to fetch participant budgets: $e');
      throw Exception('Failed to fetch participant budgets: $e');
    }
  }

  Future<ParticipantBudget> fetchBudgetForParticipant(
      String tripId, String participantId) async {
    List<ParticipantBudget> participantBudgets =
        await fetchParticipantBudgets(tripId);
    // Find the budget for the specified participant ID or throw an exception if not found.
    ParticipantBudget participantBudget = participantBudgets.firstWhere(
      (budget) => budget.participantId == participantId,
      orElse: () => throw Exception("Participant budget not found"),
    );
    return participantBudget;
  }

}
