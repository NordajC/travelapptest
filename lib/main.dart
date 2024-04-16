import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:travelapptest/trip/trip_controller.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'package:travelapptest/onboarding_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:travelapptest/authentication_repository.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // TripBinding().dependencies();
  await GetStorage.init();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then(
      (FirebaseApp value) => Get.put(AuthenticationRepository())
      );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp( MyApp());
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // Path: lib/app.dart
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
