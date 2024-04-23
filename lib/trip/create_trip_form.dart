import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelapptest/trip/trip_controller.dart';
import 'package:travelapptest/api_services/here_places_api_call.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CreateTripForm extends StatelessWidget {
  const CreateTripForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TripController controller = Get.find<TripController>();

    final OpenCageService _placesService = OpenCageService();

    TextEditingController destinationController = TextEditingController();

    void _selectDateRange(BuildContext context) async {
      final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        initialDateRange: DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(Duration(days: 7)), // Example initial range
        ),
      );
      if (picked != null) {
        controller.startDate.text =
            DateFormat('yyyy-MM-dd').format(picked.start);
        controller.endDate.text = DateFormat('yyyy-MM-dd').format(picked.end);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Trip'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.tripFormKey,
          child: Column(
            children: [
              // TextFormField(
              //   controller: controller.destination,
              //   decoration: InputDecoration(
              //     labelText: 'Destination',
              //     prefixIcon: const Icon(CupertinoIcons.map_pin_ellipse),
              //     border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(8.0)),
              //   ),
              //   validator: (value) => value == null || value.trim().isEmpty
              //       ? 'Please enter a destination'
              //       : null,
              // ),

              // TypeAheadField(itemBuilder: (context, suggestion) {
              //     return ListTile(
              //       title: Text(suggestion
              //           .toString()), // Make sure suggestion is converted to String if necessary
              //     );
              //   }, onSelected: (suggestion) {
              //     controller.destination.text = suggestion.toString();
              //   }, suggestionsCallback: (pattern) async {
              //     return await _placesService.getSuggestions(pattern);
              //   }
              // ),
  
              // TypeAheadField<String>(
              //   suggestionsCallback: (pattern) async {
              //     return await _placesService.getSuggestions(pattern);
              //   },
              //   itemBuilder: (context, suggestion) {
              //     return ListTile(
              //       title: Text(suggestion.toString()), // Assuming the suggestion is a string.
              //     );
              //   },
              //   onSelected: (suggestion) {
              //     controller.destination.text = suggestion.toString(); // Update the controller on selection
              //     print(controller.destination.text);
              //   },
              //   builder: (context, controller, focusNode) {
              //     return TextFormField(
              //       controller: controller, // This controller comes from the TypeAheadField builder
              //       focusNode: focusNode,
              //       decoration: InputDecoration(
              //         labelText: 'Destination',
              //         prefixIcon: const Icon(CupertinoIcons.map_pin_ellipse),
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(8.0),
              //         ),
              //       ),
              //       validator: (value) {
              //         if (value == null || value.trim().isEmpty) {
              //           return 'Please enter a destination';
              //         }
              //         return null; // Return null if the input is valid
              //       },
              //     );
              //   },
              // ),
              
              TypeAheadField<String>(

                // The controller for the destination
                controller: controller.destination,

                suggestionsCallback: (pattern) async {
                  return await OpenCageService().getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion.toString()),
                  );
                },
                onSelected: (suggestion) {
                  // Using this setup, the text is updated correctly in the builder below
                  controller.destination.text = suggestion.toString();
                },
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Destination',
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    // No need for onChanged; the controller setup handles updates
                  );
                },
              ),

              const SizedBox(height: 16.0),
              TextFormField(
                controller:
                    controller.startDate, // Controller for the start date
                decoration: InputDecoration(
                  labelText: 'Start and End Date',
                  prefixIcon: const Icon(CupertinoIcons.calendar),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                readOnly: true,
                onTap: () => _selectDateRange(context),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please select a date range'
                    : null,
              ),

              // const SizedBox(height: 16.0),
              // TextFormField(
              //   controller:
              //       controller.startDate, // Controller for the start date
              //   decoration: InputDecoration(
              //     labelText: 'Start Date',
              //     prefixIcon: const Icon(CupertinoIcons.calendar),
              //     border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(8.0)),
              //   ),
              //   readOnly: true,
              //   onTap: () => _selectDateRange(context),
              //   validator: (value) => value == null || value.trim().isEmpty
              //       ? 'Please select a date range'
              //       : null,
              // ),

              const SizedBox(height: 16.0),
              TextFormField(
                controller: controller.budget,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Budget',
                  prefixIcon: const Icon(CupertinoIcons.money_dollar_circle),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter a budget'
                    : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: controller.description,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: const Icon(CupertinoIcons.text_alignleft),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (controller.tripFormKey.currentState!.validate()) {
                    controller.createTrip();
                  }
                },
                child: const Text('Create Trip'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
