import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:travelapp/data/repositories.authentication/authentication_repository.dart'; // Adjust this import path to where your AuthenticationRepository is located

class OnboardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          OnboardingPage(
            title: 'Welcome to Our App',
            description: 'Discover new places and adventures.',
            // image: 'assets/onboarding1.png',
          ),
          OnboardingPage(
            title: 'Organize Your Trips',
            description: 'Plan your trips with ease and flexibility.',
            // image: 'assets/onboarding2.png',
          ),
          OnboardingPage(
            title: 'Share Your Experiences',
            description: 'Share your travel experiences with a vibrant community.',
            // image: 'assets/onboarding3.png',
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  // final String image;

  OnboardingPage({required this.title, required this.description/*, required this.image*/});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Image.asset(image), // Uncomment and use your image assets
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}