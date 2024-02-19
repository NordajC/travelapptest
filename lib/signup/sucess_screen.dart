import 'package:flutter/material.dart';

class SucessScreen extends StatelessWidget {
  SucessScreen({Key? key, required this.title, required this.subtitle, required this.onPressed, required this.buttonText}); 

  final String title, subtitle, buttonText;
  final VoidCallback onPressed;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //image logo

            //sized box
            // SizedBox(
            //   height: 16.0,
            // ),

            //title
            Text(
              title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8.0
            ),

            //sub title
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.10,
              ),
            ),

            const SizedBox(
              height: 16.0,
            ),

            //unsure if this is the right way to do it
            //resend email verification
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            )
          ]
        ),
      ),
    );
  }
}