This is a guide to installing and running the travel app NexTrip by Jun Hann Chong.
Prerequisites: Ensure you have the following installed: 

-Flutter SDK (v3.0 or later) 

-VS Code with Flutter and Dart plugins

1. Clone the repository branch called "final" or download the link on Mega/Dropbox. Dropbox is preferred as it has most dependencies installed already.

Dropbox link: https://www.dropbox.com/scl/fi/jhjmrr55u0uvwxe6fjwsc/travelapptest.zip?rlkey=nr61t1a9mi3a65ub5bs924ps2&st=onv3baul&dl=0

cloning repo code: git clone -b final https://github.com/NordajC/travelapptest.git

2. After cloning the repository or installing and extracting the folder from Mega/Dropbox, open the folder with vs code and enter "flutter pub get" to install dependencies.

3. Ensure that the project includes all necessary Firebase configuration files:

Android: google-services.json in android/app

iOS: GoogleService-Info.plist in ios/Runner

Web: Firebase configuration in web/index.html

4. To run the code 

On Mobile: Connect a mobile device or use an emulator, then run the following code in the terminal: flutter run

On Web: To launch the web version, execute: flutter run -d chrome
Alternately, locate the main.dart file in lib folder of the project and open it on VS code. After doing that press the play button located on the top right of the window by the file tabs bar.
