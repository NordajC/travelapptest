import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelapptest/trip/trip_model.dart'; // Make sure to import your ItineraryItemModel

class ItineraryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createItineraryItem(
      String tripId, String date, ItineraryItem newItem) async {
    try {
      DocumentReference docRef = _firestore
          .collection('Trips')
          .doc(tripId)
          .collection('DailyItineraries')
          .doc(date)
          .collection('Items')
          .doc(newItem.id);

      await docRef.set(newItem.toJson());
      // Optionally update the newItem with the ID from the document reference, if needed.
    } catch (e) {
      Get.snackbar('Error', 'Failed to create itinerary item: $e');
    }
  }

  // Future<List<ItineraryItem>> loadItineraryItems(String tripId) async {
  //   try {
  //     QuerySnapshot querySnapshot = await _firestore
  //         .collection('itineraryItems')
  //         .where('tripId', isEqualTo: tripId)
  //         .get();

  //     return querySnapshot.docs
  //         .map((doc) =>
  //             ItineraryItem.fromJson(doc.data() as Map<String, dynamic>))
  //         .toList();
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to load itinerary items: $e');
  //     // Handle exception by rethrowing or handling it appropriately
  //     return [];
  //   }
  // }

  Future<List<ItineraryItem>> loadItineraryItems(
      String tripId, DateTime selectedDate) async {
    try {
      // Format the date to match the document ID format used in Firestore
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedDate) + "T00:00:00.000";
      QuerySnapshot querySnapshot = await _firestore
          .collection('Trips')
          .doc(tripId)
          .collection('DailyItineraries')
          .doc(formattedDate)
          .collection('Items')
          .get();

      List<ItineraryItem> items = querySnapshot.docs
          .map((doc) =>
              ItineraryItem.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return items;
    } catch (e) {
      print("Failed to load items: $e");
      throw e; // This will help to understand the exact error
    }
  }

  // Future<void> updateItineraryItem(
  //     String tripId, ItineraryItem updatedItem) async {
  //   DocumentReference docRef = _firestore
  //       .collection('Trips')
  //       .doc(tripId)
  //       .collection('DailyItineraries')
  //       .doc(updatedItem.startTime.toIso8601String().substring(0, 10))
  //       .collection('Items')
  //       .doc(updatedItem.id);

  //   try {
  //     await docRef.update(updatedItem.toJson());
  //   } catch (e) {
  //     throw Exception('Error updating itinerary item: $e');
  //   }
  // }

  Future<void> updateItineraryItem(
      String tripId, ItineraryItem updatedItem) async {
    // Ensure the date is formatted correctly
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(updatedItem.startTime) +
            "T00:00:00.000";

    // Print out the path to see if it's constructed correctly
    String path =
        'Trips/$tripId/DailyItineraries/$formattedDate/Items/${updatedItem.id}';
    print("Attempting to update document at path: $path");

    DocumentReference docRef = _firestore
        .collection('Trips')
        .doc(tripId)
        .collection('DailyItineraries')
        .doc(formattedDate)
        .collection('Items')
        .doc(updatedItem.id);

    // First, check if the document exists
    DocumentSnapshot docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      print('Document does not exist at path: $path');
      // Handle the non-existence of the document appropriately
      return;
    }

    // If the document exists, attempt the update
    try {
      await docRef.update(updatedItem.toJson());
      print('Itinerary item updated successfully');
    } catch (e) {
      print('Error updating itinerary item: $e');
      // Handle the update error appropriately
    }
  }

  Future<void> deleteItineraryItem(
      String tripId, String itemId, DateTime itemDate) async {
    DocumentReference docRef = _firestore
        .collection('Trips')
        .doc(tripId)
        .collection('DailyItineraries')
        .doc(itemDate
            .toIso8601String()
            .substring(0, 23)) // Ensure this matches your date formatting
        .collection('Items')
        .doc(itemId);

    try {
      await docRef.delete();
    } catch (e) {
      throw Exception('Error deleting itinerary item: $e');
    }
  }

  // Additional methods as needed for your application
}
