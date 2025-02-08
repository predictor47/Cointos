# Kointos - Cryptocurrency Portfolio & News App

A modern cryptocurrency portfolio tracking and news application built with Flutter.

## Features

- Real-time cryptocurrency price tracking
- Portfolio management
- Price alerts
- News articles
- User authentication
- Rewards system
- Dark/Light theme support

## Requirements

- Flutter SDK >=3.0.0 <4.0.0
- Firebase project setup
- Android Studio / VS Code with Flutter extensions

## Setup

1. Clone the repository
```bash
git clone https://github.com/yourusername/kointos.git
cd kointos
```

2. Install dependencies
```bash
flutter pub get
```

3. Firebase Setup
- Create a new Firebase project in the [Firebase Console](https://console.firebase.google.com)
- Enable Authentication, Firestore, and Storage services
- Download and add the configuration files:
  - For Android: `google-services.json` to `android/app/`
  - For iOS: `GoogleService-Info.plist` to `ios/Runner/`
  - Run flutterfire configure to set up firebase_options.dart

4. Environment Variables
- Copy `.env.example` to `.env` and fill in the required values

## Running the App

1. Start an emulator or connect a physical device

2. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── core/           # Core functionality (routing, config, etc.)
├── data/           # Data layer (models, repositories)
├── features/       # Feature modules
│   ├── auth/       # Authentication
│   ├── home/       # Home screen
│   ├── market/     # Market data
│   └── portfolio/  # Portfolio management
├── services/       # Services (API, Firebase, etc.)
└── shared/        # Shared widgets and utilities
```

## Dependencies

- **Firebase**: Authentication, Firestore, Storage
- **State Management**: Provider
- **Networking**: Dio
- **Charts**: fl_chart
- **Local Storage**: shared_preferences
- **Other**: get_it (DI), intl, cached_network_image

## Development

- The project uses Clean Architecture principles
- Dependency Injection with get_it
- Provider for state management
- Error handling and logging system
- Analytics integration

## Contributing

1. Fork the repository
2. Create a new branch for your feature
3. Commit your changes
4. Push to your branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details
