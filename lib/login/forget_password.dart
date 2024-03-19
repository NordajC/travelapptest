import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelapptest/login/forget_password_controller.dart';
import 'package:travelapptest/validation/validation.dart';

class ForgetPassword extends StatelessWidget{
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forget Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Forget Password',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 80, 80, 80),
              ),
            ),

            const SizedBox(
              height: 8.0,
            ),

            const Text(
              'Enter your email address and we will send you a link to reset your password.',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.10,
                color: Color.fromARGB(255, 125, 125, 125),
              ),
            ),

            const SizedBox(
              height: 16.0,
            ),

            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: inputValidator.validateEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ()=> controller.sendPasswordResetEmail(),
                child: const Text('Send Email'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}