import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelapptest/edit%20profile/update_name_controller.dart';
import 'package:travelapptest/home/appbar.dart';
import 'package:travelapptest/validation/validation.dart';

class ChangeName extends StatelessWidget {
  const ChangeName({super.key,});

  @override
  Widget build(BuildContext context) {

    //final controller
    final controller = Get.put(UpdateNameController());

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Change Name'),
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("This name will appear on multiple pages."),

            SizedBox(height: 24), // Space between the text and the form

            Form(
              key: controller.updateUserNameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.firstName,

                    decoration: InputDecoration(
                      labelText: 'First name',
                      hintText: 'Enter your first name',
                    ),
                    validator: (value) => inputValidator.validateEmpty("First name", value),
                  ),

                  SizedBox(height: 24), // Space between the form and the button

                  TextFormField(
                    controller: controller.lastName,

                    decoration: InputDecoration(
                      labelText: 'First name',
                      hintText: 'Enter your first name',
                    ),
                    validator: (value) => inputValidator.validateEmpty("First name", value),
                  ),

                  SizedBox(height: 24), // Space between the form and the button

                  SizedBox(child: ElevatedButton(
                    onPressed: () => controller.updateUserName(),
                    child: Text('Save'),
                  
                  ),)
                  
                ],
              )
            ),
          ], 
        ),
      ),
    );
  }
}
