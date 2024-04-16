import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelapptest/trip/trip_model.dart';

class TripDetailsPage extends StatelessWidget {
  final TravelPlanModel trip;

  const TripDetailsPage({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use trip information to build your details page
    return Scaffold(
      appBar: AppBar(
        title: Text(trip.destination),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Build your trip details layout
            Text('Trip to: ${trip.destination}'),
            Text('Start Date: ${DateFormat('yyyy-MM-dd').format(trip.startDate)}'),
            Text('End Date: ${DateFormat('yyyy-MM-dd').format(trip.endDate)}'),
            // Add more details as required
          ],
        ),
      ),
    );
  }
}
