import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travelapptest/onboarding_screen.dart';
import 'package:get/get.dart'; // Ensure you've imported GetX

// class MyApp extends StatelessWidget {
//   // Create a future for initializing Firebase
//   final Future<FirebaseApp> _initialization = Firebase.initializeApp();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: FutureBuilder(
//         // Use the Firebase initialization future
//         future: _initialization,
//         builder: (context, snapshot) {
//           // Check for errors
//           if (snapshot.hasError) {
//             return const Scaffold(
//               backgroundColor: Colors.lightBlue,
//               body: Center(
//                 child: Text('Error initializing Firebase'),
//               ),
//             );
//           }

//           // Once complete, show your application
//           // if (snapshot.connectionState == ConnectionState.done) {
//           //   return OnboardingScreen();
//           // }

//           // Otherwise, show a loading spinner
//           return const Scaffold(
//             backgroundColor: Colors.lightBlue,
//             body: Center(
//               child: CircularProgressIndicator(
//                 color: Colors.white,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Use GetMaterialApp here
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
