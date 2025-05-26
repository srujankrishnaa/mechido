# Mechido

<p align="center">
  <img src="assets/images/app_logo.png" alt="Mechido Logo" width="200"/>
</p>

## 🔧 A Complete Vehicle Service Booking & Tracking Solution

Mechido is a comprehensive mobile application built with Flutter that connects vehicle owners with mechanics for service bookings, real-time tracking, and seamless payment processing.

## 📱 Features

### For Vehicle Owners
- **User Authentication**: Secure login/signup system with Supabase backend
- **Service Booking**: Easy booking of various vehicle services with detailed options
- **Real-Time Tracking**: Track mechanics in real-time with accurate ETA and service status
- **Payment Integration**: Secure payment processing through Razorpay
- **Booking History**: View past and upcoming service bookings
- **Rating & Feedback**: Rate mechanics and provide feedback after service completion

### For Mechanics/Service Providers
- **Service Management**: Accept and manage service requests
- **Navigation Assistance**: Get directions to customer locations
- **Service Updates**: Update service status and progress
- **Notification System**: Receive alerts for new booking requests

## 🚀 Technical Features

- **Real-time Map Tracking**: Using Flutter Map and location services
- **State Management**: Implemented with Flutter Bloc and Provider
- **Backend Integration**: Supabase for database and authentication
- **Responsive UI**: Beautiful and intuitive interface with custom animations
- **Offline Support**: Partial functionality available without internet connection
- **Push Notifications**: For booking updates and service reminders

## 🛠️ Architecture

Mechido follows a clean architecture approach with:

- **Models**: Data classes representing application entities
- **Services**: Business logic and API integration
- **Providers**: State management
- **Screens**: UI components organized by functionality
- **Widgets**: Reusable UI components

## 📋 Dependencies

- **State Management**: flutter_bloc, provider
- **Backend & Auth**: supabase_flutter
- **Maps & Location**: flutter_map, latlong2, location
- **Payment**: razorpay_flutter
- **UI Components**: flutter_svg, cached_network_image, shimmer, lottie
- **Storage**: hive, shared_preferences
- And many more...

## 🔧 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/srujankrishnaa/mechido.git
   ```

2. Install dependencies:
   ```bash
   cd mechido
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## 🖥️ Environment Setup

Make sure you have Flutter installed. For help getting started with Flutter, view the [online documentation](https://flutter.dev/docs).

### Requirements
- Flutter 3.0+
- Dart 3.0+
- Android Studio or VS Code
- Android SDK
- iOS development tools (for macOS)

## 📱 Screenshots

(Screenshots will be added soon)

## 🔄 Workflow

1. User signs up/logs in
2. Browses available services
3. Adds desired services to cart
4. Proceeds to checkout and payment
5. Tracks mechanic in real-time
6. Receives service and provides feedback

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Contact

Srujan Krishna - [@srujankrishnaa](https://github.com/srujankrishnaa)

## 💡 Acknowledgements

- Flutter team for the amazing framework
- Supabase for the powerful backend services
- All contributors and testers

---

Made with ❤️ by Srujan Krishna
