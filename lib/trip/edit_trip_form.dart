import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelapptest/trip/trip_controller.dart';
import 'package:travelapptest/trip/trip_model.dart';

class EditTripForm extends StatelessWidget {
  final String tripId;

  EditTripForm({Key? key, required this.tripId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TripController controller = Get.find<TripController>();

    // Find the trip by ID from the loaded trips list or handle a null trip
    // Find the trip by ID from the loaded trips list
    final trip = controller.trips.firstWhereOrNull((t) => t.id == tripId);
    
    // Check if the trip is not found and handle the scenario
    if (trip == null) {
      // Schedule a post-frame callback to manage state after the widget build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Error',
          'Trip not found',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back(); // Navigate back if the trip is not found
      });
      return Scaffold(); // Return an empty scaffold while handling the error
    }

    // Initialize controllers with the trip data
    final destinationController = TextEditingController(text: trip.destination);
    final startDateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(trip.startDate));
    final endDateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(trip.endDate));
    final budgetController = TextEditingController(text: trip.participantBudgets.first.budget.toString());
    final descriptionController = TextEditingController(text: trip.description);

    void _selectDateRange(BuildContext context) async {
      final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        initialDateRange: DateTimeRange(
          start: trip.startDate,
          end: trip.endDate,
        ),
      );
      if (picked != null) {
        startDateController.text = DateFormat('yyyy-MM-dd').format(picked.start);
        endDateController.text = DateFormat('yyyy-MM-dd').format(picked.end);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Edit Trip')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: destinationController,
              decoration: InputDecoration(
                  labelText: 'Destination',
                  prefixIcon: Icon(CupertinoIcons.map_pin_ellipse)
                ),
              readOnly: true,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: startDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Start and End Dates',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _selectDateRange(context),
            ),
            // TextFormField(
            //   controller: endDateController,
            //   readOnly: true,
            //   decoration: InputDecoration(
            //     labelText: 'End Date',
            //     suffixIcon: Icon(Icons.calendar_today),
            //   ),
            //   onTap: () => _selectDateRange(context),
            // ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Budget',
                  prefixIcon: Icon(CupertinoIcons.money_dollar_circle),
                ),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                trip.destination = destinationController.text;
                trip.startDate = DateFormat('yyyy-MM-dd').parse(startDateController.text);
                trip.endDate = DateFormat('yyyy-MM-dd').parse(endDateController.text);
                trip.participantBudgets.first.budget = double.tryParse(budgetController.text) ?? 0.0;
                trip.description = descriptionController.text;
                controller.updateTrip(trip);
              },
              child: Text('Update Trip'),
            ),
          ],
        ),
      ),
    );
  }
}
