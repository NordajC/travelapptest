import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:travelapptest/login/forget_password_controller.dart';
import 'package:travelapptest/login/login.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Reset Password'),
        actions: [IconButton(onPressed: () => Get.back(), icon: const Icon(CupertinoIcons.clear))],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
               Text(
                email,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 80, 80, 80),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.10,
                  color: Color.fromARGB(255, 125, 125, 125),
                ),
              ),

              const SizedBox(
                height: 8.0,
              ),

              const Text(
                'A link to reset your password has been sent to your email. Please check your email and follow the instructions to reset your password.',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.10,
                  color: Color.fromARGB(255, 125, 125, 125),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAll(() => const LoginScreen()),
                  child: const Text('Done'),
                ),
              ),
              
              const SizedBox(
                height: 16.0,
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => ForgetPasswordController.instance.resendPasswordResetEmail(email),
                  child: const Text('Resend Email'),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}