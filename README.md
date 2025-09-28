PGold - Cryptocurrency & Giftcard Trading Platform
A Flutter-based mobile application for trading cryptocurrencies and giftcards with real-time rate calculations and secure authentication.

🚀 Features
Authentication & Security
Secure User Registration with email verification

OTP Verification with resend functionality

Secure Storage using Flutter Secure Storage

Cryptocurrency Trading
Buy/Sell Crypto at market rates

Rate Calculations for multiple cryptocurrencies

Live USD Rates integration

Giftcard Trading
Sell/Buy Giftcards with instant rate calculations

Multi-country Support with local currencies

Card Range Selection with receipt categories

Dynamic Rate Calculation based on card type and amount

🛠 Tech Stack
Flutter 3.25 (Dart)

Riverpod for state management

Dio for HTTP requests

Flutter Secure Storage for secure data storage

Google Fonts for typography

Pin Code Fields for OTP input

GIF View for animations

📋 Prerequisites
Before running this project, ensure you have:

Flutter SDK (version 3.0 or higher)

Dart SDK (version 2.38 or higher)

Android Studio or VS Code with Flutter extension

Android Emulator or Physical Device with USB debugging enabled

Git for version control

🔧 Installation & Setup
1. Clone the Repository
bash
git clone <your-repository-url>
cd pgold
2. Install Dependencies
bash
flutter pub get

4. Platform Setup
For Android:
Ensure Android SDK is installed and configured

Enable developer options on your device/emulator


🏃‍♂️ Running the Application
Development Mode
bash
# Run in debug mode
flutter run

# Run on specific device
flutter run -d <device_id>

# Run with hot reload
flutter run --hot
Build for Production
Android APK:
bash
flutter build apk --release