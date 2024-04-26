import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelapptest/trip/trip_model.dart';
import 'itinerary_repository.dart';

class ItineraryBinding extends Bindings {
  @override
  void dependencies() {
    // Retrieve `tripId` from arguments passed during navigation
    String tripId = Get.arguments as String;

    Get.lazyPut<ItineraryRepository>(() => ItineraryRepository());
    Get.lazyPut(() => ItineraryController(
          itineraryRepository: Get.find(),
          tripId: tripId,
        ));
  }
}

class ItineraryController extends GetxController {
  final ItineraryRepository itineraryRepository;
  RxList<ItineraryItem> itineraryItems = <ItineraryItem>[].obs;
  Rxn<ItineraryItem> currentItineraryItem = Rxn<ItineraryItem>();
  var isLoading = false.obs;

  final String tripId;
  ItineraryController({
    required this.itineraryRepository,
    required this.tripId,
  });

  @override
  void onInit() {
    super.onInit();
    // You may want to load itinerary items when the controller is initialized.
    // For instance, fetch itinerary items for a specific trip here.
    // loadItineraryItems(tripId);
  }

  // Call this method when you want to fetch itinerary items, such as after user login, or trip selection.
  // void loadItineraryItems(String tripId) async {
  //   isLoading.value = true;
  //   try {
  //     var items = await itineraryRepository.loadItineraryItems(tripId);
  //     itineraryItems.assignAll(items);
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to load itinerary items: $e');
  //   }
  // }

  void loadItineraryItems(String tripId, DateTime selectedDate) async {
    isLoading.value = true;
    try {
      var items =
          await itineraryRepository.loadItineraryItems(tripId, selectedDate);
      if (items.isNotEmpty) {
        itineraryItems.assignAll(items);
        print(
            "Loaded ${items.length} items for tripId: $tripId and date: $selectedDate");
      } else {
        print("No items found for tripId $tripId on date $selectedDate");
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load itinerary items: $e');
      print("Error loading items: $e");
    } finally {
      isLoading.value = false;
    }
  }
  //not this one
  // void createItineraryItem(ItineraryItem newItem, String date) async {
  //   try {
  //     await itineraryRepository.createItineraryItem(tripId, date, newItem);
  //     itineraryItems.add(newItem);
  //     Get.snackbar('Success', 'Itinerary item created successfully');
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to create itinerary item: $e');
  //   }
  // }

  //previous createItineraryItem working
  // void createItineraryItem(
  //     String tripId, ItineraryItem newItem, String date) async {
  //   try {
  //     await itineraryRepository.createItineraryItem(tripId, date, newItem);
  //     itineraryItems.add(newItem);
  //     Get.snackbar('Success', 'Itinerary item created successfully');
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to create itinerary item: $e');
  //   }
  // }

  //previous updateItineraryItem working
  // void updateItineraryItem(String tripId, ItineraryItem updatedItem) async {
  //   try {
  //     await itineraryRepository.updateItineraryItem(tripId, updatedItem);
  //     int index =
  //         itineraryItems.indexWhere((item) => item.id == updatedItem.id);
  //     if (index != -1) {
  //       itineraryItems[index] = updatedItem;
  //       itineraryItems.refresh();
  //       Get.snackbar('Success', 'Itinerary item updated successfully');
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to update itinerary item: $e');
  //   }
  // }

  //previous deleteItineraryItem working
  // void deleteItineraryItem(
  //     String tripId, String itemId, DateTime itemDate) async {
  //   try {
  //     await itineraryRepository.deleteItineraryItem(tripId, itemId, itemDate);
  //     itineraryItems.removeWhere((item) => item.id == itemId);
  //     Get.snackbar('Success', 'Itinerary item deleted successfully');
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to delete itinerary item: $e');
  //   }
  // }

  void createItineraryItem(
      String tripId, ItineraryItem newItem, String date) async {
    try {
      await itineraryRepository.createItineraryItem(tripId, date, newItem);
      itineraryItems.add(newItem);
      // Check if paidBy is not null and price is not null before updating the budget
      if (newItem.price != null && newItem.paidBy != null) {
        updateParticipantBudget(tripId, newItem.paidBy!, newItem.price!, true);
      }
      Get.snackbar('Success', 'Itinerary item created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create itinerary item: $e');
    }
  }

  void updateItineraryItem(String tripId, ItineraryItem updatedItem) async {
    try {
      ItineraryItem? oldItem =
          itineraryItems.firstWhereOrNull((item) => item.id == updatedItem.id);
      await itineraryRepository.updateItineraryItem(tripId, updatedItem);
      double oldPrice = oldItem?.price ?? 0;
      double newPrice = updatedItem.price ?? 0;
      if (oldPrice != newPrice) {
        if (oldItem != null && oldItem.paidBy != null) {
          updateParticipantBudget(tripId, oldItem.paidBy!, oldPrice, false);
        }
        if (updatedItem.paidBy != null) {
          updateParticipantBudget(tripId, updatedItem.paidBy!, newPrice, true);
        }
      }
      int index =
          itineraryItems.indexWhere((item) => item.id == updatedItem.id);
      if (index != -1) {
        itineraryItems[index] = updatedItem;
        itineraryItems.refresh();
        Get.snackbar('Success', 'Itinerary item updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update itinerary item: $e');
    }
  }

  void deleteItineraryItem(
      String tripId, String itemId, DateTime itemDate) async {
    try {
      ItineraryItem? oldItem =
          itineraryItems.firstWhereOrNull((item) => item.id == itemId);
      if (oldItem != null && oldItem.price != null && oldItem.paidBy != null) {
        await itineraryRepository.deleteItineraryItem(tripId, itemId, itemDate);
        updateParticipantBudget(tripId, oldItem.paidBy!, oldItem.price!, false);
        itineraryItems.removeWhere((item) => item.id == itemId);
        Get.snackbar('Success', 'Itinerary item deleted successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete itinerary item: $e');
    }
  }

  void updateParticipantBudget(
      String tripId, String participantId, double amount, bool add) {
    // Forward the update request to the repository with proper sign based on add or subtract
    itineraryRepository.updateParticipantBudget(
        tripId, participantId, amount, add);
  }

  List<DateTime> getDateRangeForTrip(DateTime startDate, DateTime endDate) {
    List<DateTime> dateList = [];
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate.add(Duration(days: 1)))) {
      dateList.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }
    return dateList;
  }

  void handleItemCosts(ItineraryItem item) {
    calculateAndSplitCosts(item, tripId);
  }

  void calculateAndSplitCosts(ItineraryItem item, String tripId) {
    double totalCost = item.price ?? 0.0;
    int numParticipants = item.participants?.length ?? 0;

    if (item.splitType == 'equal' && numParticipants > 0) {
      double splitAmount = totalCost / numParticipants;
      item.splitDetails =
          item.participants!.asMap().map((_, id) => MapEntry(id, splitAmount));
    } else if (item.splitType == 'custom' && item.splitDetails != null) {
      double customTotal = item.splitDetails!.values.reduce((a, b) => a + b);
      if (customTotal != totalCost) {
        throw Exception('Custom splits do not add up to the total cost.');
      }
    }

    item.splitDetails?.forEach((participantId, amount) {
      updateParticipantBudget(tripId, participantId, amount, true);
    });
  }

  void addExpense(String tripId, String payerId, List<String> participantIds,
      double amount, String paymentType) {
    if (paymentType == 'individual') {
      updateParticipantBudget(tripId, payerId, amount, true);
    } else if (paymentType == 'group') {
      updateParticipantBudget(tripId, payerId, amount, true);
      double share = amount / participantIds.length;
      for (String participantId in participantIds) {
        if (participantId != payerId) {
          updateParticipantBudget(tripId, participantId, share, false);
        }
      }
    }
  }

  void handleDebtSettlement(
      String tripId, String debtorId, String creditorId, double paymentAmount) {
    // Use complex function to adjust debts appropriately
    itineraryRepository.updateBudgetAndDebt(
        tripId, creditorId, debtorId, paymentAmount, false);
  }

  Future<void> handleNewExpense(
    String tripId,
    ItineraryItem updatedItem,
    String payerId,
    double expenseAmount,
    DateTime selectedDate,
  ) async {
    // First, update the itinerary item itself.
    await itineraryRepository.updateItineraryItem(tripId, updatedItem);
    loadItineraryItems(tripId, selectedDate);

    // After updating the itinerary item, update the participant's spendings.
    // handles the logic here
    // directly in the controller if it's simple enough.
    // await updateParticipantSpendings(tripId, payerId, expenseAmount);
  }

  //fetch itinerary items by a specific item id

  Future<void> fetchItineraryItemById(
      String tripId, DateTime date, String itemId) async {
    try {
      isLoading(
          true); // If using GetX, to notify observers that loading has started

      print(" UP HERE Fetching itinerary item: $itemId");

      var item =
          await itineraryRepository.fetchItineraryItem(tripId, date, itemId);
      currentItineraryItem(item); // Notify observers with the new item

      print("Fetched itinerary item: $item");
      print("HERE");
    } catch (e) {
      // Handle errors, could log them or show user-friendly error messages
      Get.snackbar("Error", "Failed to fetch itinerary item: $e");
    } finally {
      isLoading(false); // Notify observers that loading has finished
    }
  }
}
