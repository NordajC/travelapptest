import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:travelapptest/login/login_controller.dart';
import 'package:travelapptest/signup/signup.dart';
import 'package:travelapptest/validation/validation.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome text
        Text(
          'Login to Your Account',
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.25,
            color: Color.fromARGB(255, 80, 80, 80),
          ),
        ),

        // Space between heading and subheading
        SizedBox(
          height: 8.0,
        ),

        // Subheading
        Text(
          'Access your itineraries, saved places, and travel plans. Connect with fellow travelers and share your experiences.',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.10,
            color: Color.fromARGB(255, 125, 125, 125),
          ),
        ),
      ],
    );
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({
    super.key,
  });

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64.0),
        child: Column(
          children: [
            // Email input
            TextFormField(
              controller: controller.email,
              validator: (value) => inputValidator.validateEmail(value),
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(CupertinoIcons.mail),
              ),
            ),

            // Space between inputs
            const SizedBox(
              height: 16.0,
            ),

            //Password
            Obx(
              () => TextFormField(
                controller: controller.password,
                expands: false,
                obscureText: controller.hidePassword.value,
                validator: (value) => inputValidator.passwordValidator(value),
                decoration: InputDecoration(
                  // icon: Icon(Icons.lock),
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value
                        ? CupertinoIcons.eye_slash
                        : CupertinoIcons.eye),
                  ),
                  prefixIcon: const Icon(CupertinoIcons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 8.0,
            ),

            // Remember me and forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remember me
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: (value) => {controller.rememberMe.value = !controller.rememberMe.value}, // Checkbox is disabled
                      ),
                    ),
                    const Text('Remember me'),
                  ],
                ),

                // Forget password
                const TextButton(
                    onPressed: null, // Disable the button
                    child: Text('Forget Password')),
              ],
            ),

            const SizedBox(
              height: 16.0,
            ),

            // Sign in button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.emailAndPasswordSignIn(),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor, // Button color
                  onPrimary: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded edges
                  ),
                ),
                child: const Text('Sign In'),
              ),
            ),

            const SizedBox(
              height: 16.0,
            ),
            // Create account button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const SignupScreen()),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded edges
                  ),
                ),
                child: const Text('Create Account'),
              ),
            ),

            // const SizedBox(
            //   height: 8.0,
            // ),
          ],
        ),
      ),
    );
  }
}

class FormDivider extends StatelessWidget {
  const FormDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
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
            'Or sign in with',
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
    );
  }
}

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
