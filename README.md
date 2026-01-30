Countries Explorer
A Flutter mobile app for exploring countries worldwide with REST Countries API integration. Features include country browsing, real-time search, favorites management, and offline support.

 Quick Start
Prerequisites
Flutter SDK (≥3.24.3)

Dart (≥3.120.0)

Android Studio / VS Code

Installation
bash
git clone https://github.com/kelvinC7/Countries-App.git
cd Countries-App
flutter pub get
flutter run

Architecture
State Management: BLoC/Cubit for predictable state flow
Architecture: Clean Architecture + BLoC pattern
Local Storage: SharedPreferences for persistent data
API Strategy: Two-step fetching with smart caching
UI Framework: Material Design 3 with shimmer effects

Key Dependencies
flutter_bloc: State management

get: Navigation & dependency injection

http: HTTP client for api data fetching

shared_preferences: Local storage

cached_network_image: Image caching

shimmer: Loading effects

Project Structure
text
lib/
├── main.dart
├── di/              # Dependency injection
├── data/            # API client & storage
├── home/            # Home feature
├── detail/          # Detail feature
├── favorites/       # Favorites feature
└── common/          # Shared components
Testing
bash
flutter test        # Unit tests
flutter analyze     # Code analysis
 License
MIT License
