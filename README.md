========= Setup Instructions  =============


1. Clone the Repository
Clone the GitHub repository:
git clone (https://github.com/rakib2010/test-ecommerce.git)
cd your-repository
2. Set Up Firebase
Go to Firebase Console (https://console.firebase.google.com/).
Create a new project.
Add your Android app, download google-services.json (Android)
Place the file in the correct folder:
Android: android/app/
3. keep the java key store key in key.properties file which is located android/app/keystore/simple_ecommerce_keystore.jks
4. Configure Firebase Authentication
In Firebase, enable Google Sign-In in the Authentication section.
5. Install Dependencies
Run the following commands to install dependencies:
flutter pub get
6. Run the App
Run the project:
flutter run
7. Google Sign-In
Users can log in using Google after Firebase setup is complete.
