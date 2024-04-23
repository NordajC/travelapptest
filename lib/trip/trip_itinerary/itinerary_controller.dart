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

  // void createItineraryItem(ItineraryItem newItem, String date) async {
  //   try {
  //     await itineraryRepository.createItineraryItem(tripId, date, newItem);
  //     itineraryItems.add(newItem);
  //     Get.snackbar('Success', 'Itinerary item created successfully');
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to create itinerary item: $e');
  //   }
  // }

  void createItineraryItem(
      String tripId, ItineraryItem newItem, String date) async {
    try {
      await itineraryRepository.createItineraryItem(tripId, date, newItem);
      itineraryItems.add(newItem);
      Get.snackbar('Success', 'Itinerary item created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create itinerary item: $e');
    }
  }

  void updateItineraryItem(String tripId, ItineraryItem updatedItem) async {
    try {
      await itineraryRepository.updateItineraryItem(tripId, updatedItem);
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
      await itineraryRepository.deleteItineraryItem(tripId, itemId, itemDate);
      itineraryItems.removeWhere((item) => item.id == itemId);
      Get.snackbar('Success', 'Itinerary item deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete itinerary item: $e');
    }
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
}
