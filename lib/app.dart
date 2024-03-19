import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travelapptest/bindings/general_bindings.dart';
import 'package:travelapptest/onboarding_screen.dart';
import 'package:get/get.dart'; // Ensure you've imported GetX
import 'package:google_fonts/google_fonts.dart';


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

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp( // Use GetMaterialApp here
//       title: 'Flutter Demo',
//       initialBinding: GeneralBindings(), // Add the GeneralBindings here
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         textTheme: GoogleFonts.latoTextTheme(
//           Theme.of(context).textTheme,
//         ),
//       ),
      
//       home: const Scaffold(
//         backgroundColor: Colors.lightBlue,
//         body: Center(
//           child: CircularProgressIndicator(
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialBinding: GeneralBindings(),
      theme: ThemeData(
        // Neutral colors for a less tinted effect
        primarySwatch: Colors.grey,
        primaryColor: Colors.grey[200], // Neutral grey shade

        scaffoldBackgroundColor: const Color(0xFFFFFAFA),

        textTheme: GoogleFonts.latoTextTheme(
          ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF313131),
          ).textTheme.apply(
            bodyColor: const Color(0xFF313131),
            displayColor: const Color(0xFF313131),
          ),
        ).copyWith(
          displayLarge: GoogleFonts.lato(color: const Color(0xFF616161)),
          displayMedium: GoogleFonts.lato(color: const Color(0xFF616161)),
          bodyLarge: GoogleFonts.lato(color: const Color(0xFF919191)),
          bodyMedium: GoogleFonts.lato(color: const Color(0xFF919191)),
          bodySmall: GoogleFonts.lato(color: const Color(0xFFC2C2C2)),
        ),

        disabledColor: const Color(0xFFC2C2C2),
        hintColor: const Color(0xFF616161),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: const Color(0xFF616161)),
          hintStyle: TextStyle(color: const Color(0xFF616161)),
        ),

        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.grey[200],
        ),
      ),
      home: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
