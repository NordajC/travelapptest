import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelapptest/home/appbar.dart';
import 'package:travelapptest/trip/trip_controller.dart';
import 'package:travelapptest/trip/trip_itinerary/edit_itinerary_form.dart';
import 'package:travelapptest/trip/trip_itinerary/itinerary_add_item_form.dart';
import 'itinerary_controller.dart'; // Make sure this import path matches your project structure
import 'package:travelapptest/trip/trip_model.dart'; // Import your ItineraryItemModel
import 'package:intl/intl.dart';
import 'dart:ui';

class ItineraryPage extends GetView<ItineraryController> {
  final String tripId;
  final TripController tripController = Get.find();
  final Rx<TravelPlanModel?> selectedTrip = Rx<TravelPlanModel?>(null);
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  ItineraryPage({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    tripController.fetchTripById(tripId).then((data) {
      selectedTrip.value = data;
      selectedDate.value = data?.startDate; // Initially select the start date
      controller.loadItineraryItems(
          tripId,
          data?.startDate ??
              DateTime.now()); // Load items for the start date or current date
      print(
          'Fetching details for trip ID: $tripId, startDate: ${data?.startDate}');
    }).catchError((error) {
      Get.snackbar('Error', 'Failed to fetch trip details');
    });

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              selectedTrip.value?.destination ?? 'Itinerary',
              overflow: TextOverflow.ellipsis,
            )),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Obx(() {
            if (selectedTrip.value == null) {
              return Center(child: CircularProgressIndicator());
            }
            return CalendarStrip(
              startDate: selectedTrip.value!.startDate,
              endDate: selectedTrip.value!.endDate,
              selectedDate: selectedDate.value,
              onSelectDate: (DateTime date) {
                selectedDate.value = date;
                controller.loadItineraryItems(tripId,
                    date); // Reload itinerary items for new selected date
              },
            );
          }),
          SizedBox(height: 10),
          // Expanded(
          //   child: Obx(() {
          //     if (controller.isLoading.isTrue) {
          //       return Center(child: CircularProgressIndicator());
          //     }
          //     var sortedItems = controller.itineraryItems
          //         .where((item) =>
          //             selectedDate.value != null &&
          //             item.startTime.toLocal().day == selectedDate.value!.day)
          //         .toList();
          //     sortedItems.sort((a, b) =>
          //         a.startTime.compareTo(b.startTime)); // Sort by start time

          //     return ListView.builder(
          //       itemCount: sortedItems.length,
          //       itemBuilder: (context, index) {
          //         final item = sortedItems[index];
          //         return ItineraryItemCard(itineraryItem: item);
          //       },
          //     );
          //   }),
          // ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.isTrue) {
                return Center(child: CircularProgressIndicator());
              }
              var sortedItems = controller.itineraryItems
                  .where((item) =>
                      selectedDate.value != null &&
                      item.startTime.toLocal().day == selectedDate.value!.day)
                  .toList();
              sortedItems.sort((a, b) =>
                  a.startTime.compareTo(b.startTime)); // Sort by start time

              return ListView.builder(
                itemCount: sortedItems.length,
                itemBuilder: (context, index) {
                  final item = sortedItems[index];
                  return ItineraryItemCard(
                    itineraryItem: item,
                    tripId: tripId,
                    onDelete: (DateTime date) =>
                        controller.deleteItineraryItem(tripId, item.id, date),
                    onEdit: (ItineraryItem updatedItem) {
                      // Navigate to a screen or show a form to edit the item
                      // For simplicity, assume there is a method to handle this
                      // showEditForm(context, item, tripId);
                      Get.to(
                          () => EditActivityForm(tripId: tripId, item: item));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedDate.value != null && selectedTrip.value != null) {
            Get.to(() => AddActivityForm(
                tripId: tripId, date: selectedDate.value!.toIso8601String()));
          } else {
            Get.snackbar(
                "Error", "Please select a date before adding an activity");
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}

class CalendarStrip extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? selectedDate;
  final Function(DateTime) onSelectDate;

  CalendarStrip({
    required this.startDate,
    required this.endDate,
    required this.selectedDate,
    required this.onSelectDate,
  });

  List<DateTime> getDateRange(DateTime startDate, DateTime endDate) {
    List<DateTime> dateList = [];
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate.add(Duration(days: 1)))) {
      dateList.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }
    return dateList;
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> dateRange = getDateRange(startDate, endDate);

    return Container(
      height: 70,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: dateRange.length,
        itemBuilder: (context, index) {
          DateTime date = dateRange[index];
          bool isSelected = selectedDate != null &&
              date.difference(selectedDate!).inDays == 0 &&
              date.day == selectedDate!.day;

          return DateTile(
            date: date,
            isSelected: isSelected,
            onSelect: () => onSelectDate(date),
          );
        },
      ),
    );
  }
}

class DateTile extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onSelect;

  DateTile({
    required this.date,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue
              : Colors.transparent, // Selected day highlighted
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: Colors.blue, width: 2)
              : null, // Border to indicate selection
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date).toUpperCase(),
              style: TextStyle(color: isSelected ? Colors.white : Colors.black),
            ),
            Text(
              date.day.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Define a Map for category icons just for example purposes. Update this based on your actual categories and icons.
const Map<String, IconData> categoryIcons = {
  'Transportation': Icons.directions_bus,
  'Meals': Icons.local_dining,
  'Activities': Icons.run_circle,
  'Accommodation': Icons.hotel,
  'Shopping': Icons.shopping_bag,
  'Personal Time': Icons.person,
  'Other': Icons.more_horiz,
};

// Define a Map for category colors. Update this as needed.
const Map<String, Color> categoryColors = {
  'Transportation': Colors.blue,
  'Meals': Colors.green,
  'Activities': Colors.orange,
  'Accommodation': Color.fromARGB(255, 255, 120, 165),
  'Shopping': Colors.purple,
  'Personal Time': Colors.red,
  'Other': Colors.grey,
};

class ItineraryItemCard extends StatelessWidget {
  final ItineraryItem itineraryItem;
  final String tripId;
  final Function(DateTime date) onDelete;
  final Function(ItineraryItem item) onEdit;

  ItineraryItemCard({
    required this.itineraryItem,
    required this.tripId,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon = categoryIcons[itineraryItem.category] ?? Icons.error;
    Color color = categoryColors[itineraryItem.category] ?? Colors.grey;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
                width: 10,
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)))),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: color, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                            child: Text(itineraryItem.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: color))),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: color, size: 16),
                        SizedBox(width: 8),
                        Text(
                          "${DateFormat('h:mm a').format(itineraryItem.startTime.toLocal())} - ${DateFormat('h:mm a').format(itineraryItem.endTime.toLocal())}",
                          style: TextStyle(color: color.withOpacity(0.9)),
                        ),
                      ],
                    ),

                    // SizedBox(height: 10), // Add some spacing between items
                    Row(
                      children: [
                        Icon(Icons.pin_drop, color: color, size: 16),
                        SizedBox(width: 8),
                        Text(itineraryItem.location,
                            style: TextStyle(color: color.withOpacity(0.8))),
                      ],
                    ),

                    // if (itineraryItem.price != null)
                    //   Text("\£${itineraryItem.price!.toStringAsFixed(2)}"),
                    if (itineraryItem.notes != null &&
                        itineraryItem.notes!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: Text(
                          "${itineraryItem.notes}",
                          style: TextStyle(),
                        ),
                      ),

                    SizedBox(height: 12),

                    if (itineraryItem.price != null)
                      Wrap(
                        children: [
                          Chip(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            side: BorderSide.none,
                            labelPadding: EdgeInsets.symmetric(
                                horizontal: -2, vertical: 0),
                            label: Text(
                                "\£${itineraryItem.price!.toStringAsFixed(2)}",
                                style: TextStyle(color: Colors.blue[800])),
                            backgroundColor: Colors.blue[100],
                          ),
                          if (itineraryItem.paidBy != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Chip(
                                label: Text("Paid by ${itineraryItem.paidBy!}"),
                                backgroundColor: Colors.orange[200],
                              ),
                            ),
                        ],
                      ),
                    if (itineraryItem.price == null)
                      TextButton(
                        onPressed: () {
                          // TODO: Implement the showAddPriceForm function
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blue[100],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0)),
                        child: Text(
                          'Add Cost',
                          style: TextStyle(
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => _showMenu(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
              onTap: () {
                Navigator.of(context).pop();
                onEdit(itineraryItem);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                Navigator.of(context).pop();
                onDelete(itineraryItem.startTime);
              },
            ),
          ],
        );
      },
    );
  }
}

// Utility function to generate a list of dates for the current week
List<DateTime> generateWeekDates() {
  DateTime now = DateTime.now();
  int currentWeekday = now.weekday;
  DateTime startOfWeek = now.subtract(Duration(days: currentWeekday - 1));
  return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
}

void parseDate(String dateString) {
  DateFormat format = DateFormat('yyyy-MM-dd');
  DateTime dateTime = format.parse(dateString);
  print(dateTime);
}
