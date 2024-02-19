import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelapptest/onboarding_controller.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:travelapp/data/repositories.authentication/authentication_repository.dart'; // Adjust this import path to where your AuthenticationRepository is located

// class OnboardingScreen extends StatelessWidget {
//   final PageController _pageController = PageController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         children: <Widget>[
//           OnboardingPage(
//             title: 'Welcome to Our App',
//             description: 'Discover new places and adventures.',
//             // image: 'assets/onboarding1.png',
//           ),
//           OnboardingPage(
//             title: 'Organize Your Trips',
//             description: 'Plan your trips with ease and flexibility.',
//             // image: 'assets/onboarding2.png',
//           ),
//           OnboardingPage(
//             title: 'Share Your Experiences',
//             description: 'Share your travel experiences with a vibrant community.',
//             // image: 'assets/onboarding3.png',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class OnboardingPage extends StatelessWidget {
//   final String title;
//   final String description;
//   // final String image;

//   OnboardingPage({required this.title, required this.description/*, required this.image*/});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           // Image.asset(image), // Uncomment and use your image assets
//           SizedBox(height: 20),
//           Text(
//             title,
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//           Text(
//             description,
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }


////////////////////////////////////////////////////
///
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtain an instance of the OnboardingController
    final onBoardingController controller = Get.put(onBoardingController());

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.updatePageIndicator,
                children: const <Widget>[
                  OnboardingPage(
                    title: 'Welcome to Our App',
                    description: 'Discover new places and adventures.',
                  ),
                  OnboardingPage(
                    title: 'Organize Your Trips',
                    description: 'Plan your trips with ease and flexibility.',
                  ),
                  OnboardingPage(
                    title: 'Share Your Experiences',
                    description: 'Share your travel experiences with a vibrant community.',
                  ),
                ],
              ),
            ),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) => buildIndicator(index, controller.currentPageIndex.value)),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.nextPage(),
              child: Obx(() => Text(controller.currentPageIndex.value == 2 ? 'Finish' : 'Next')),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator(int index, int currentPageIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: currentPageIndex == index ? 30 : 10,
      decoration: BoxDecoration(
        color: currentPageIndex == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;

  const OnboardingPage({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}