import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example trip data
    final String tripImage = 'london.jpg'; // Make sure to add an image to your assets
    final String tripName = 'Trip to Paris';
    final String tripBudget = '\$1200';
    final String tripDate = 'April 10 - 15, 2023';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.landscape),
                title: Text(tripName),
                subtitle: Text('Budget: $tripBudget - Date: $tripDate'),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0), // Optional, for a rounded image.
                child: Image.asset(
                  tripImage,
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  TextButton(
                    child: const Text('VIEW DETAILS'),
                    onPressed: () {
                      // Implement navigation to trip details
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement action to add more trips
        },
        tooltip: 'Add Trip',
        child: const Icon(Icons.add),
      ),
    );
  }
}
