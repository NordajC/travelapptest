import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelapptest/authentication_repository.dart';
import 'package:travelapptest/signup/verify_email_controller.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => AuthenticationRepository.instance.logout(),
            icon: const Icon(Icons.logout),
          ),
        ]
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //image logo

            //sized box
            // SizedBox(
            //   height: 16.0,
            // ),

            //title
            const Text(
              'Verify Your Email',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8.0
            ),

            //sub title
            const Text(
              'A verification email has been sent to your email address. Please verify your email to continue.',
              style: TextStyle(
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
                onPressed: () => controller.checkEmailVerificationStatus(),
                child: const Text('Continue'),
              ),
            ),

            const SizedBox(
              height: 16.0,
            ),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.sendEmailVerification(),
                child: const Text('Resend Email Verification'),
              ),
            ),
            


          ],
        ),
      ),
    );
  }
}