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

  //fetch itinerary item by item id
  Future<ItineraryItem> fetchItineraryItem(
      String tripId, DateTime selectedDate, String itemId) async {
    try {
      // Format the date to match the document ID format used in Firestore
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedDate) + "T00:00:00.000";

      // Get the document reference
      DocumentReference docRef = _firestore
          .collection('Trips')
          .doc(tripId)
          .collection('DailyItineraries')
          .doc(formattedDate)
          .collection('Items')
          .doc(itemId);

      // Fetch the document
      DocumentSnapshot docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw Exception("Itinerary item not found.");
      }

      // Convert the document into an ItineraryItem instance
      ItineraryItem item =
          ItineraryItem.fromJson(docSnapshot.data() as Map<String, dynamic>);

      return item;
    } catch (e) {
      print("Failed to fetch itinerary item: $e");
      throw e; // Re-throw the exception to handle it in the calling code
    }
  }

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
  // In your ItineraryRepository last code

  // void updateParticipantBudget(
  //     String tripId, String participantId, double amount, bool add) {
  //   DocumentReference participantRef = _firestore
  //       .collection('Trips')
  //       .doc(tripId)
  //       .collection('ParticipantBudgets')
  //       .doc(participantId);

  //   _firestore
  //       .runTransaction((transaction) async {
  //         DocumentSnapshot snapshot = await transaction.get(participantRef);

  //         if (!snapshot.exists) {
  //           throw Exception("Participant does not exist!");
  //         }

  //         // Extract current spendings and update based on the 'add' flag
  //         double currentSpendings =
  //             (snapshot.data() as Map<String, dynamic>)['spendings'].toDouble();
  //         double updatedAmount =
  //             add ? currentSpendings + amount : currentSpendings - amount;

  //         transaction.update(participantRef, {'spendings': updatedAmount});
  //       })
  //       .then((_) => print("Budget updated successfully"))
  //       .catchError((error) => print("Error updating budget: $error"));
  // }

  void updateParticipantBudget(
      String tripId, String participantId, double amount, bool add) {
    DocumentReference tripRef = _firestore.collection('Trips').doc(tripId);

    _firestore
        .runTransaction((transaction) async {
          DocumentSnapshot tripSnapshot = await transaction.get(tripRef);

          if (!tripSnapshot.exists) {
            throw Exception("Trip does not exist!");
          }

          final tripData = tripSnapshot.data();
          if (tripData == null) {
            throw Exception("Trip data is null!");
          }

          // Ensure tripData is not null before casting it to Map<String, dynamic>
          final Map<String, dynamic> tripDataMap =
              tripData as Map<String, dynamic>;

          // Use ?. to invoke [] conditionally in case tripDataMap['participantBudgets'] is null
          final participantBudgets =
              tripDataMap['participantBudgets'] as List<dynamic>? ?? [];

          // Find the participant's budget entry
          Map<String, dynamic>? participantBudget =
              participantBudgets.firstWhere(
            (budget) => budget['participantId'] == participantId,
            orElse: () => null,
          );

          if (participantBudget == null) {
            throw Exception("Participant budget does not exist!");
          }

          // Extract current spendings and update based on the 'add' flag
          double currentSpendings =
              participantBudget['spendings']?.toDouble() ?? 0.0;
          double updatedSpendings =
              add ? currentSpendings + amount : currentSpendings - amount;

          // Update spendings in the participant's budget
          participantBudget['spendings'] = updatedSpendings;

          // Update the participant budgets array within the transaction
          transaction
              .update(tripRef, {'participantBudgets': participantBudgets});
        })
        .then((_) => print("Budget updated successfully"))
        .catchError((error) => print("Error updating budget: $error"));
  }

  // void updateBudgetAndDebt(String tripId, String payerId, String debtorId,
  //     double amount, bool isPayment) async {
  //   DocumentReference tripRef = _firestore.collection('Trips').doc(tripId);

  //   _firestore
  //       .runTransaction((transaction) async {
  //         DocumentSnapshot tripSnapshot = await transaction.get(tripRef);
  //         if (!tripSnapshot.exists) {
  //           throw Exception("Trip does not exist!");
  //         }

  //         // Properly casting the data to Map<String, dynamic>
  //         Map<String, dynamic> data =
  //             tripSnapshot.data() as Map<String, dynamic>? ?? {};
  //         List<dynamic> participantBudgets =
  //             data['participantBudgets'] as List<dynamic>? ?? [];

  //         // Find payer and debtor in the participant budgets
  //         Map<String, dynamic>? payerBudget = participantBudgets.firstWhere(
  //             (budget) => budget['participantId'] == payerId,
  //             orElse: () => null);
  //         Map<String, dynamic>? debtorBudget = participantBudgets.firstWhere(
  //             (budget) => budget['participantId'] == debtorId,
  //             orElse: () => null);

  //         if (payerBudget != null && (isPayment || debtorId == payerId)) {
  //           // Update payer's spendings if it's a direct payment or paying for oneself
  //           payerBudget['spendings'] =
  //               (payerBudget['spendings'] as num) + amount;
  //         }

  //         if (payerBudget != null && debtorBudget != null && !isPayment) {
  //           // Update debtor's debt to payer
  //           Map<String, double> debts =
  //               Map<String, double>.from(debtorBudget['debts'] ?? {});
  //           debts[payerId] = (debts[payerId] ?? 0) + amount;
  //           debtorBudget['debts'] = debts;
  //         }

  //         // Write the updated budgets back to the Firestore
  //         transaction
  //             .update(tripRef, {'participantBudgets': participantBudgets});
  //       })
  //       .then((_) => print("Budget and debts updated successfully"))
  //       .catchError(
  //           (error) => print("Error updating budget and debts: $error"));
  // }

  void updateBudgetAndDebt(String tripId, String payerId, String debtorId,
      double amount, bool isPayment) async {
    DocumentReference tripRef = _firestore.collection('Trips').doc(tripId);

    _firestore
        .runTransaction((transaction) async {
          DocumentSnapshot tripSnapshot = await transaction.get(tripRef);
          if (!tripSnapshot.exists) {
            throw Exception("Trip does not exist!");
          }

          Map<String, dynamic> tripData =
              tripSnapshot.data() as Map<String, dynamic>;
          List<dynamic> participantBudgets =
              tripData['participantBudgets'] as List<dynamic>;

          for (var budget in participantBudgets) {
            if (budget['participantId'] == payerId) {
              budget['spendings'] +=
                  amount; // Assuming this is the correct logic
            }
            if (isPayment && budget['participantId'] == debtorId) {
              // Adjust debts here
              Map<String, dynamic> debts =
                  budget['debts'] as Map<String, dynamic>;
              debts[payerId] = (debts[payerId] ?? 0) + amount;
              budget['debts'] = debts;
            }
          }

          // Update the trip document with the modified participant budgets
          transaction
              .update(tripRef, {'participantBudgets': participantBudgets});
        })
        .then((_) => print("Budget and debts updated successfully"))
        .catchError(
            (error) => print("Error updating budget and debts: $error"));
  }

  // Future<void> addExpenseToItineraryItem(
  //     String tripId,
  //     String itemId,  // You get the ID from the ItineraryItem passed
  //     String payerId,
  //     double amount) async {
  //   // Format the date to match the Firestore document ID structure
  //   // Let's assume the ItineraryItem model includes a DateTime attribute named startTime
  //   String formattedDate = DateFormat('yyyy-MM-dd').format(item.startTime) + "T00:00:00.000";

  //   // Construct the path to the itinerary item's document using the tripId and itemId
  //   String path = 'Trips/$tripId/DailyItineraries/$formattedDate/Items/$itemId';

  //   // Get a reference to the document
  //   DocumentReference itineraryItemRef = _firestore.doc(path);

  //   // Prepare the expense details
  //   Map<String, dynamic> expenseDetails = {
  //     'amount': amount,
  //     'paidBy': payerId,
  //     'timestamp': FieldValue.serverTimestamp(), // Use server timestamp for consistency
  //   };

  //   // Execute a transaction to ensure atomicity of the update
  //   await _firestore.runTransaction((transaction) async {
  //     // Get the current data to ensure it exists
  //     DocumentSnapshot snapshot = await transaction.get(itineraryItemRef);
  //     if (!snapshot.exists) {
  //       throw Exception('Itinerary item does not exist');
  //     }

  //     // Update the itinerary item with the new expense
  //     transaction.update(itineraryItemRef, {
  //       'expenses': FieldValue.arrayUnion([expenseDetails])
  //     });
  //   });

  //   // Optionally handle success or failure in the calling code
  //   print('Expense added to the itinerary item successfully');
  // }

  //expense handling
  Future<List<ItineraryItem>> fetchAllItineraryItems(String tripId) async {
    List<ItineraryItem> allItineraryItems = [];

    // First, retrieve all the dates (as sub-collection IDs) for the trip
    QuerySnapshot dateCollections = await _firestore
        .collection("Trips")
        .doc(tripId)
        .collection("DailyItineraries")
        .get();

    // For each date, retrieve all items and add them to the list
    for (var dateDoc in dateCollections.docs) {
      String date = dateDoc.id; // Assuming the ID is the date
      QuerySnapshot itemsSnapshot = await _firestore
          .collection("Trips")
          .doc(tripId)
          .collection("DailyItineraries")
          .doc(date)
          .collection("Items")
          .get();

      for (var itemDoc in itemsSnapshot.docs) {
        ItineraryItem item =
            ItineraryItem.fromJson(itemDoc.data() as Map<String, dynamic>);
        allItineraryItems.add(item);
      }
    }

    return allItineraryItems;
  }

  Future<List<DateTime>> fetchItineraryDates(String tripId) async {
    // Assuming 'DailyItineraries' has documents named by date, fetch those document IDs.
    var itineraryDatesDocs = await _firestore
        .collection('Trips')
        .doc(tripId)
        .collection('DailyItineraries')
        .get();

    // Extract the dates from the document IDs or any date field within the documents.
    List<DateTime> itineraryDates =
        itineraryDatesDocs.docs.map((doc) => DateTime.parse(doc.id)).toList();

    return itineraryDates;
  }
}
