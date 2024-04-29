import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travelapptest/bindings/general_bindings.dart';
import 'package:travelapptest/onboarding_screen.dart';
import 'package:get/get.dart'; 
import 'package:google_fonts/google_fonts.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialBinding: GeneralBindings(),
      theme: ThemeData(
        // Neutral colors for a less tinted effect
        primarySwatch: Colors.grey,
        primaryColor: Color(0xFF5E6EFF), // Neutral grey shade

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
