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
      final QuerySnapshot participantTripsSnapshot = await _db
          .collection("Trips")
          .where('participantIds', arrayContains: userId)
          .get();

      final allTrips = participantTripsSnapshot.docs
          .map((doc) => TravelPlanModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();

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
          'Error fetching trip: $e'); // Optionally rethrow to handle it further up the call stack
    }
  }
}
