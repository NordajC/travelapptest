import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelapptest/trip/trip_model.dart';
import 'package:travelapptest/trip/trip_repository.dart';
import 'package:intl/intl.dart';
import 'package:travelapptest/trip/trip_itinerary/itinerary_controller.dart';

class AddActivityForm extends StatefulWidget {
  final String tripId;
  final String
      date; // This should be the ISO string of the date for which you are adding the activity

  AddActivityForm({Key? key, required this.tripId, required this.date})
      : super(key: key);

  @override
  _AddActivityFormState createState() => _AddActivityFormState();
}

class _AddActivityFormState extends State<AddActivityForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  // final TextEditingController _priceController = TextEditingController();
  // final TextEditingController _paidByController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // DateTime get selectedDate => DateFormat("yyyy-MM-dd").parse(widget.date);

  DateTime selectedDate = DateTime.now(); // Initialize selectedDate with the current date and time

  String? _selectedCategory;
  final List<String> _categories = [
    'Transportation',
    'Meals',
    'Activities',
    'Accommodation',
    'Shopping',
    'Personal Time',
    'Other'
  ];

  final ItineraryController itineraryController = Get.find();


  Future<void> _selectDateTime(BuildContext context, TextEditingController controller, {bool isStartTime = true}) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      DateTime dateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      controller.text = DateFormat('HH:mm').format(dateTime);
    }
  }

  void addActivity() {
    if (_formKey.currentState!.validate()) {
      DateTime startTime = DateFormat("yyyy-MM-dd HH:mm").parse('${DateFormat('yyyy-MM-dd').format(selectedDate)} ${_startTimeController.text}');
      DateTime endTime = DateFormat("yyyy-MM-dd HH:mm").parse('${DateFormat('yyyy-MM-dd').format(selectedDate)} ${_endTimeController.text}');

      if (endTime.isBefore(startTime)) {
        Get.snackbar("Error", "End time must be after start time.");
        return;
      }

      ItineraryItem newItem = ItineraryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        startTime: startTime,
        endTime: endTime,
        location: _locationController.text,
        category: _selectedCategory,
        notes: _notesController.text,
      );

      itineraryController.createItineraryItem(widget.tripId, newItem, DateFormat('yyyy-MM-dd').format(selectedDate) + "T00:00:00.000");
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch initial data if needed
    // Example: load additional details about the trip or set default values

    // selectedDate = widget.date.toString();

    selectedDate = DateTime.parse(widget.date);
    print('Received date: ${widget.date}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Activity")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Activity Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the activity name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _startTimeController,
                decoration: InputDecoration(labelText: 'Start Time'),
                readOnly: true,
                onTap: () => _selectDateTime(context, _startTimeController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the start time';
                  }
                  try {
                    DateTime startTime = DateFormat("HH:mm").parse(value);
                    DateTime endTime = DateFormat("HH:mm").parse(_endTimeController.text);
                    if (startTime.isAfter(endTime)) {
                      return 'Start time must be before end time';
                    }
                  } catch (_) {
                    return 'Invalid time format';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endTimeController,
                decoration: InputDecoration(labelText: 'End Time'),
                readOnly: true,
                onTap: () => _selectDateTime(context, _endTimeController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the end time';
                  }
                  try {
                    DateTime endTime = DateFormat("HH:mm").parse(value);
                    DateTime startTime = DateFormat("HH:mm").parse(_startTimeController.text);
                    if (endTime.isBefore(startTime)) {
                      return 'End time must be after start time';
                    }
                  } catch (_) {
                    return 'Invalid time format';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              // TextFormField(
              //   controller: _priceController,
              //   decoration: InputDecoration(labelText: 'Price'),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter the price';
              //     }
              //     return null;
              //   },
              // ),
              // TextFormField(
              //   controller: _paidByController,
              //   decoration: InputDecoration(labelText: 'Paid By'),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter who paid for the activity';
              //     }
              //     return null;
              //   },
              // ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList()
                  ..add(DropdownMenuItem(
                    value: 'Custom',
                    child: Text('Custom - Add your own'),
                  )),
                onChanged: (value) {
                  if (value == 'Custom') {
                    // Prompt to add a new category
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Enter Custom Category'),
                          content: TextField(
                            autofocus: true,
                            decoration:
                                InputDecoration(hintText: 'Custom Category'),
                            onSubmitted: (val) {
                              setState(() {
                                _categories.add(val);
                                _selectedCategory = val;
                                Navigator.pop(context);
                              });
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Notes'),
                maxLines: 3, // Allow for longer text entries
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a Snackbar.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Processing Data')),
                    );
                    addActivity();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidDateTime(String datetime) {
    try {
      DateTime.parse(datetime);
      return true;
    } catch (_) {
      return false;
    }
  }

  // void addActivity() {
  //   if (_formKey.currentState!.validate()) {
  //     // Convert text to DateTime objects for comparison
  //     DateTime startTime = DateTime.parse(_startTimeController.text);
  //     DateTime endTime = DateTime.parse(_endTimeController.text);

  //     // Check if the start time is after the end time
  //     if (startTime.isAfter(endTime)) {
  //       Get.snackbar("Error", "The end time must be after the start time.");
  //       return; // Stop the submission process
  //     }

  //     ItineraryItem newItem = ItineraryItem(
  //       id: DateTime.now()
  //           .millisecondsSinceEpoch
  //           .toString(), // Unique ID for each activity
  //       name: _nameController.text,
  //       startTime: startTime,
  //       endTime: endTime,
  //       location: _locationController.text,
  //       // price: double.parse(_priceController.text),
  //       // paidBy: _paidByController.text,
  //       category: _selectedCategory,
  //       notes: _notesController.text,
  //     );

  //     // Save to Firestore under the specific trip and date
  //     itineraryController.createItineraryItem(newItem, widget.date);
  //     Get.back(); // Optionally navigate back or clear the form
  //   }
  // }

  // Function to create a new itinerary item with time combined with the selected date
}
