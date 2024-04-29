import 'package:get/get.dart';
import 'package:travelapptest/trip/trip_itinerary/itinerary_controller.dart';
import 'package:travelapptest/trip/trip_itinerary/itinerary_repository.dart';
import 'package:travelapptest/trip/trip_model.dart';
import 'package:travelapptest/trip/trip_repository.dart';

class ExpenseBinding extends Bindings {
  @override
  void dependencies() {
    // Retrieve `tripId` from arguments passed during navigation
    String tripId = Get.arguments as String;

    Get.lazyPut
      (() => ExpenseController(tripId: tripId, itineraryRepository: Get.find()));
  }
}

class ExpenseController extends GetxController {
  final ItineraryRepository itineraryRepository;
  var categoryExpenses = <String, double>{}.obs;

  // ItineraryRepository itineraryRepository = Get.find<ItineraryRepository>();

  final String tripId;

  ExpenseController({required this.tripId, required this.itineraryRepository});

  @override
  void onInit() {
    super.onInit();
    aggregateExpensesByCategory(tripId);
  }

  void aggregateExpensesByCategory(String tripId) async {
    List<ItineraryItem> allItineraryItems = [];
    List<DateTime> itineraryDates = await itineraryRepository.fetchItineraryDates(tripId);

    for (DateTime date in itineraryDates) {
      List<ItineraryItem> dailyItems = await itineraryRepository.loadItineraryItems(tripId, date);
      allItineraryItems.addAll(dailyItems);
    }

    Map<String, double> tempCategoryExpenses = {};
    for (ItineraryItem item in allItineraryItems) {
      double expenseAmount = item.price ?? item.generalExpenseAmount ?? 0.0;
      String category = item.category ?? 'General';
      tempCategoryExpenses.update(category, (value) => value + expenseAmount,
          ifAbsent: () => expenseAmount);
    }
    categoryExpenses.assignAll(tempCategoryExpenses);
  }
}
