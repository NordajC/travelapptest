// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.only(
//           top: 56.0,
//           left: 24.0,
//           bottom: 24.0,
//           right: 24.0,
//         ),
//         child: Column(children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               //insert an image of the app logo here when created

//               //Welcome text
//               const Text(
//                 'Login to Your Account',
//                 style: TextStyle(
//                   fontSize: 26.0,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 0.25,
//                 ),
//               ),

//               //space between heading and sub heading
//               const SizedBox(
//                 height: 8.0,
//               ),

//               //Subheading
//               const Text(
//                 'Access your itineraries, saved places, and travel plans. Connect with fellow travelers and share your experiences.',
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.w500,
//                   letterSpacing: 0.10,
//                 ),
//               ),

//               //login form
//               Form(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 32.0),
//                   child: Column(
//                     children: [
//                       //email input
//                       TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'Email',
//                         ),
//                       ),

//                       //space between input
//                       const SizedBox(
//                         height: 8,
//                       ),

//                       //password input
//                       TextFormField(
//                         decoration: const InputDecoration(
//                             labelText: 'Password',
//                             suffixIcon: Icon(CupertinoIcons.eye_slash)),
//                       ),

//                       const SizedBox(
//                         height: 8.0,
//                       ),

//                       //remember me and forgot password
//                       const Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           //remember me
//                           Row(
//                             children: [
//                               Checkbox(
//                                 value: true,
//                                 // Remove the onChanged property
//                                 onChanged: null,
//                               ),
//                               Text('Remember me'),
//                             ],
//                           ),

//                           //forget password
//                           TextButton(
//                               onPressed: null, child: Text('Forget Password')),
//                         ],
//                       ),

//                       const SizedBox(
//                         height: 16.0,
//                       ),

//                       //sign in
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           child: const Text('Sign In'),
//                         ),
//                       ),

//                       const SizedBox(
//                         height: 16.0,
//                       ),
//                       //create account

//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           child: const Text('Create Account'),
//                         ),
//                       ),

//                       const SizedBox(
//                         height: 16.0,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               //divider
//               const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Divider(
//                     color: Colors.grey,
//                     thickness: 0.5,
//                     indent: 60,
//                     endIndent: 5,
//                   )
//                 ],
//               ),
//             ],
//           )
//         ]),
//       ),
//     ));
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelapptest/login/login_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 56.0,
            left: 24.0,
            bottom: 24.0,
            right: 24.0,
          ),
          child: Column(
            children: [
              // logo, title, sub title
              LoginHeader(),
              // Login form
              LoginForm(),

              // Divider
              FormDivider(),

              SizedBox(
                height: 16.0,
              ),

              // Sign in with Google button
              SocialButtons(),
            ],
          ),
          // ],
        ),
      ),
    );
    // );
  }
}







