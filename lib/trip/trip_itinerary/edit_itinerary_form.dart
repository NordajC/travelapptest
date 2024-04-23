import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelapptest/trip/trip_model.dart';
import 'package:travelapptest/trip/trip_itinerary/itinerary_controller.dart';

class EditActivityForm extends StatefulWidget {
  final String tripId;
  final ItineraryItem item;

  EditActivityForm({Key? key, required this.tripId, required this.item})
      : super(key: key);

  @override
  _EditActivityFormState createState() => _EditActivityFormState();
}

class _EditActivityFormState extends State<EditActivityForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _paidByController;
  late TextEditingController _notesController;
  late String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _startTimeController = TextEditingController(text: DateFormat('HH:mm').format(widget.item.startTime));
    _endTimeController = TextEditingController(text: DateFormat('HH:mm').format(widget.item.endTime));
    _locationController = TextEditingController(text: widget.item.location);
    _priceController = TextEditingController(text: widget.item.price?.toStringAsFixed(2));
    _paidByController = TextEditingController(text: widget.item.paidBy);
    _notesController = TextEditingController(text: widget.item.notes);
    _selectedCategory = widget.item.category;
  }

  Future<void> _selectDateTime(BuildContext context, TextEditingController controller, {bool isStartTime = true}) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      DateTime dateTime = DateTime(
        widget.item.startTime.year,
        widget.item.startTime.month,
        widget.item.startTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      controller.text = DateFormat('HH:mm').format(dateTime);
    }
  }

  void updateActivity() {
    if (_formKey.currentState!.validate()) {
      DateTime startTime = DateFormat("yyyy-MM-dd HH:mm").parse('${DateFormat('yyyy-MM-dd').format(widget.item.startTime)} ${_startTimeController.text}');
      DateTime endTime = DateFormat("yyyy-MM-dd HH:mm").parse('${DateFormat('yyyy-MM-dd').format(widget.item.startTime)} ${_endTimeController.text}');

      if (endTime.isBefore(startTime)) {
        Get.snackbar("Error", "End time must be after start time.");
        return;
      }

      ItineraryItem updatedItem = ItineraryItem(
        id: widget.item.id,
        name: _nameController.text,
        startTime: startTime,
        endTime: endTime,
        location: _locationController.text,
        price: double.tryParse(_priceController.text),
        paidBy: _paidByController.text.isNotEmpty ? _paidByController.text : null,
        category: _selectedCategory,
        notes: _notesController.text,
        votes: widget.item.votes, // Keep existing votes
        suggestedBy: widget.item.suggestedBy, // Keep existing suggestedBy
        status: widget.item.status, // Keep existing status
      );

      ItineraryController itineraryController = Get.find();
      itineraryController.updateItineraryItem(widget.tripId, updatedItem);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Activity")),
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
              ),
              TextFormField(
                controller: _endTimeController,
                decoration: InputDecoration(labelText: 'End Time'),
                readOnly: true,
                onTap: () => _selectDateTime(context, _endTimeController),
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                controller: _paidByController,
                decoration: InputDecoration(labelText: 'Paid By'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: <String>[
                  'Transportation',
                  'Meals',
                  'Activities',
                  'Accommodation',
                  'Shopping',
                  'Personal',
                  'Other'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateActivity,
                child: Text('Update Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
