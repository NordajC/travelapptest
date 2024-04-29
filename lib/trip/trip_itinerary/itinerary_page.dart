import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelapptest/expense/expense_controller.dart';
import 'package:travelapptest/expense/expense_page.dart';
import 'package:travelapptest/home/appbar.dart';
import 'package:travelapptest/login/user_controller.dart';
import 'package:travelapptest/trip/trip_controller.dart';
import 'package:travelapptest/trip/trip_itinerary/edit_itinerary_form.dart';
import 'package:travelapptest/trip/trip_itinerary/itinerary_add_item_form.dart';
import 'package:travelapptest/trip/trip_repository.dart';
import 'package:travelapptest/user/user_model.dart';
import 'package:travelapptest/user/user_repository.dart';
import 'itinerary_controller.dart'; 
import 'package:travelapptest/trip/trip_model.dart'; 
import 'package:intl/intl.dart';
import 'dart:ui';

class ItineraryPage extends GetView<ItineraryController> {
  final String tripId;
  final TripController tripController = Get.find();
  final Rx<TravelPlanModel?> selectedTrip = Rx<TravelPlanModel?>(null);
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ItineraryController itineraryController = Get.find();

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

      trackedReturnItemDate(selectedDate.value!);
    }).catchError((error) {
      Get.snackbar('Error', 'Failed to fetch trip details');
    });

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              selectedTrip.value?.destination ?? 'Itinerary',
              overflow: TextOverflow.ellipsis,
            )),
        actions: [
          IconButton(
            icon: Icon(Icons.attach_money_outlined),
            onPressed: () {
              Get.to(() => ExpenseOverviewPage(tripId: tripId,),
                  binding: ExpenseBinding(), arguments: tripId);
              print(tripId);
            },
          ),
        ],
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
                    onOpenAddExpenseDialog: () => {
                      openAddExpenseDialog(context, tripId, item.id),
                    },
                    onDelete: (DateTime date) =>
                        controller.deleteItineraryItem(tripId, item.id, date),
                    onEdit: (ItineraryItem updatedItem) {
                      // Navigate to a screen or show a form to edit the item
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
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF5E6EFF),
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
            onSelect: () => {onSelectDate(date), trackedReturnItemDate(date)},
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
              ? Color(0xFF5E6EFF)
              : Colors.transparent, // Selected day highlighted
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: Color(0xFF5E6EFF), width: 2)
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

// Define a Map for category icons just for example purposes. 
const Map<String, IconData> categoryIcons = {
  'Transportation': Icons.directions_bus,
  'Meals': Icons.local_dining,
  'Activities': Icons.run_circle,
  'Accommodation': Icons.hotel,
  'Shopping': Icons.shopping_bag,
  'Personal Time': Icons.person,
  'Other': Icons.more_horiz,
};

// Define a Map for category colors. 
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

  final VoidCallback onOpenAddExpenseDialog;

  TripController tripController = Get.find();

  ItineraryItemCard({
    required this.itineraryItem,
    required this.tripId,
    required this.onDelete,
    required this.onEdit,
    required this.onOpenAddExpenseDialog,
  }) {
    // Fetch and store the username when the widget is initialized
    if (itineraryItem.paidBy != null) {
      tripController.fetchAndStoreUserName(itineraryItem.paidBy!);
    }
  }

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

                    // SizedBox(height: 10), 
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
                      Obx(() => Wrap(
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
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    side: BorderSide.none,
                                    label: Text(
                                        "Paid by ${tripController.userNames[itineraryItem.paidBy]?.value ?? 'Loading...'}",
                                        style: TextStyle(color: Colors.blue)),
                                    backgroundColor: Colors.blue[100],
                                  ),
                                ),
                            ],
                          )),
                    if (itineraryItem.price == null)
                      TextButton(
                        onPressed: () {
                          tripController.fetchTripById(tripId).then((trip) {
                            openAddExpenseDialog(
                                context, tripId, itineraryItem.id);
                          });

                          print("item/activity id: ${itineraryItem.id}");
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

void openAddExpenseDialog(
    BuildContext context, String tripId, String itemId) async {
  try {
    TripRepository tripRepository = Get.find();
    UserRepository userRepository = Get.find();

    List<ParticipantBudget> participants =
        await tripRepository.fetchParticipantBudgets(tripId);

    if (participants.isEmpty) {
      throw Exception("No participants found for trip $tripId");
    }

    // Concurrently fetch all usernames 
    List<Future<UserModel>> fetchUserFutures = participants
        .map((participant) =>
            userRepository.fetchUserById(participant.participantId))
        .toList();

    // Resolve all futures to get user models
    List<UserModel> users = await Future.wait(fetchUserFutures);
    List<String> participantUsernames =
        users.map((user) => user.username).toList();

    showDialog(
      context: context,
      builder: (context) => AddExpenseDialog(
        tripId: tripId,
        participants: participants,
        participantUsernames: participantUsernames,
        itemId: itemId,
      ),
    );
  } catch (e) {
    print("Error opening add expense dialog: $e"); // More detailed logging
    Get.snackbar("Error", "Failed to load participant details. Error: $e");
  }
}

class AddExpenseDialog extends StatefulWidget {
  final List<ParticipantBudget>
      participants; 
  final List<String> participantUsernames;
  final String tripId;
  final String itemId;

  AddExpenseDialog({
    Key? key,
    required this.participants,
    required this.participantUsernames,
    required this.tripId,
    required this.itemId,
  }) : super(key: key);

  @override
  _AddExpenseDialogState createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPayer;
  double? _amount;
  String _splitType = 'equal';
  Map<String, double> customSplits = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Expense'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                onSaved: (val) => _amount = double.tryParse(val!),
              ),
              DropdownButtonFormField<String>(
                value: _selectedPayer,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPayer = newValue;
                  });
                },
                items: List.generate(widget.participants.length, (index) {
                  return DropdownMenuItem<String>(
                    value: widget.participants[index].participantId,
                    child: Text(widget.participantUsernames[index]),
                  );
                }),
                decoration: InputDecoration(labelText: 'Who paid?'),
                isExpanded: true,
              ),
              ListTile(
                title: const Text('Paid for themselves'),
                leading: Radio(
                  value: 'individual',
                  groupValue: _splitType,
                  onChanged: (String? value) {
                    setState(() {
                      _splitType = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Paid for everyone'),
                leading: Radio(
                  value: 'onePaysForAll',
                  groupValue: _splitType,
                  onChanged: (String? value) {
                    setState(() {
                      _splitType = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
            child: Text('Save'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (_amount != null && _selectedPayer != null) {
                  
                  ItineraryController itineraryController = Get.find();

                  TripController tripController = Get.find();

                  itineraryController.addExpense(
                      widget.tripId,
                      _selectedPayer!,
                      widget.participants.map((p) => p.participantId).toList(),
                      _amount!,
                      _splitType == 'individual' ? 'individual' : 'group');

                  await loadSelectedItemData(
                      widget.tripId, trackedValue, widget.itemId);

                  if (_amount != null && _selectedPayer != null) {
                    print("selected payerId: $_selectedPayer");
                    print(
                        'current item id:${itineraryController.currentItineraryItem.value?.id}');

                    ItineraryItem updatedItem = ItineraryItem(
                      id: itineraryController.currentItineraryItem.value!
                          .id, // Provide a default id if null
                      name: itineraryController
                              .currentItineraryItem.value?.name ??
                          'default_name', // Provide a default name if null
                      startTime: itineraryController
                              .currentItineraryItem.value?.startTime ??
                          DateTime.now(), // Provide a default startTime if null
                      endTime: itineraryController
                              .currentItineraryItem.value?.endTime ??
                          DateTime.now().add(Duration(
                              hours: 1)), // Provide a default endTime if null
                      location: itineraryController
                              .currentItineraryItem.value?.location ??
                          'default_location', // Provide a default location if null
                      category: itineraryController
                              .currentItineraryItem.value?.category ??
                          "",
                      price: _amount ?? 0.0,
                      paidBy: _selectedPayer ?? "",
                      notes: itineraryController
                              .currentItineraryItem.value?.notes ??
                          "",
                      votes: itineraryController
                              .currentItineraryItem.value?.votes ??
                          {}, // Provide a default value if null
                      suggestedBy: itineraryController
                              .currentItineraryItem.value?.suggestedBy ??
                          "", // Provide a default value if null
                      status: "paid",
                      generalExpenseAmount: itineraryController
                              .currentItineraryItem
                              .value
                              ?.generalExpenseAmount ??
                          0.0, // Provide a default value if null
                      generalExpenseDescription: itineraryController
                              .currentItineraryItem
                              .value
                              ?.generalExpenseDescription ??
                          "", // Provide a default value if null
                      generalExpensePaidBy: itineraryController
                              .currentItineraryItem
                              .value
                              ?.generalExpensePaidBy ??
                          "", // Provide a default value if null
                      splitDetails: itineraryController
                              .currentItineraryItem.value?.splitDetails ??
                          {}, // Provide a default value if null
                      participants: itineraryController
                              .currentItineraryItem.value?.participants ??
                          [], // Provide a default value if null
                      paymentStatus: itineraryController
                              .currentItineraryItem.value?.paymentStatus ??
                          {}, // Provide a default value if null
                      splitType:
                          _splitType ?? "", // Provide a default value if null
                    );

                    itineraryController.handleNewExpense(
                      widget.tripId,
                      updatedItem,
                      _selectedPayer!,
                      _amount!,
                      trackedValue,
                    );
                  }

                  Navigator.of(context).pop(); // Close the dialog
                }
              }
            }),
      ],
    );
  }
}

// Original function
DateTime returnItemDate(DateTime itemDate) {
  print("itemDate: $itemDate");
  return itemDate;
}

// Wrapper function
DateTime trackedReturnItemDate(DateTime itemDate) {
  // Call the original function
  DateTime result = returnItemDate(itemDate);

  // Assign the returned value to the global variable
  trackedValue = result; 

  return result;
}

DateTime trackedValue = DateTime.now();

Future<void> loadSelectedItemData(
    String tripId, DateTime itemDate, String itemId) async {
  ItineraryController itineraryController = Get.find();
  await itineraryController.fetchItineraryItemById(tripId, itemDate, itemId);
}
