import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:travelapptest/signup/signup_form.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // logo, title, sub title
              // LoginHeader(),
              const Text(
                'Register an Account',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),

              const SizedBox(
                height: 8.0,
              ),

              const SignupForm(),

              const SizedBox(
                height: 8.0,
              ),

              //Divider
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      endIndent: 5,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Or Create An Account With',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.10,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Divider(
                      indent: 5,
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 8.0,
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Button color
                    onPrimary: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded edges
                    ),
                  ),
                  icon: Icon(Icons.login), // Google icon
                  label: Text('Sign in with Google'),
                ),
              )
            ],
          ),
        )));
  }
}

