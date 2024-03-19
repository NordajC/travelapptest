import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelapptest/signup/signup_contoller.dart';
import 'package:travelapptest/validation/validation.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          //First & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  expands: false,
                  validator: (value) => inputValidator.validateEmpty('First name',value),
                  decoration: InputDecoration(
                    // icon: Icon(Icons.person),
                    labelText: 'First Name',
                    prefixIcon: const Icon(CupertinoIcons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: TextFormField(
                  expands: false,
                  validator: (value) => inputValidator.validateEmpty('Last name',value),
                  controller: controller.lastName,
                  decoration: InputDecoration(
                    // icon: Icon(Icons.person),
                    labelText: 'Last Name',
                    prefixIcon: const Icon(CupertinoIcons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 16.0,
          ),

          //username
          TextFormField(
            expands: false,
            controller: controller.username,
            validator: (value) => inputValidator.validateEmpty('Username',value),
            decoration: InputDecoration(
              // icon: Icon(Icons.person)
              labelText: 'Username',
              prefixIcon: const Icon(CupertinoIcons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),

          const SizedBox(
            height: 16.0,
          ),

          //Email
          TextFormField(
            expands: false,
            controller: controller.email,
            validator: (value) => inputValidator.validateEmail(value),
            decoration: InputDecoration(
              // icon: Icon(Icons.email),
              labelText: 'Email',
              prefixIcon: const Icon(CupertinoIcons.mail),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),

          const SizedBox(
            height: 16.0,
          ),

          //Phone Number
          TextFormField(
            validator: (value) => inputValidator.phoneNumberValidator(value),
            expands: false,
            controller: controller.phoneNumber,
            decoration: InputDecoration(
              // icon: Icon(Icons.lock),
              labelText: 'Phone Number',
              prefixIcon: Icon(CupertinoIcons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),

          const SizedBox(
            height: 16.0,
          ),

          //Password
          Obx (
          () => TextFormField(
              controller: controller.password,
              expands: false,
              obscureText: controller.hidePassword.value,
              validator: (value) => inputValidator.passwordValidator(value),
              decoration: InputDecoration(
                // icon: Icon(Icons.lock),
                labelText: 'Password',
                suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value ? CupertinoIcons.eye_slash: CupertinoIcons.eye),
                  ),
                prefixIcon: const Icon(CupertinoIcons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 16.0,
          ),

          //Terms and Conditions
          Row(
            children: [
              SizedBox(
                width: 24.0,
                height: 24.0,
                child: Obx(
                  ()=> Checkbox(
                    value: controller.privacyPolicy.value,
                    onChanged: (value) => controller.privacyPolicy.value =  !controller.privacyPolicy.value,
                  ),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              const Text.rich(TextSpan(children: [
                TextSpan(text: 'I agree to the '),
                TextSpan(
                    text: 'Terms and Conditions.',
                    style: TextStyle(color: Colors.blue)),
                // TextSpan(text: ' and '),
                // TextSpan(
                //     text: 'Privacy Policy', style: TextStyle(color: Colors.blue)),
              ]))
            ],
          ),

          const SizedBox(
            height: 16.0,
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              child: const Text('Create Account'),
            ),
          ),
        ],
      )
    );
  }
}
