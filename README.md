<p align="center">
  <img src="images/icon.png" alt="App Icon" width="120">
</p>


<h1 align="center">Parrot Speak English</h1>

<p align="center">
  <img src="images/featureGraphic.png" alt="Feature Graphic" width="80%">
</p>

## ✨ Features

<p align="center">
  <img src="images/1_en-US.png" alt="Feature 1" width="15%">
  <img src="images/2_en-US.png" alt="Feature 2" width="15%">
  <img src="images/3_en-US.png" alt="Feature 3" width="15%">
  <img src="images/4_en-US.png" alt="Feature 4" width="15%">
  <img src="images/5_en-US.png" alt="Feature 5" width="15%">
  <img src="images/6_en-US.png" alt="Feature 6" width="15%">
</p>

Master English Vocabulary & Grammar with Ease!

Our app goes beyond vocabulary! Now, in addition to learning 6,000+ of the most common words from the Oxford Dictionary, you can also improve your grammar with our new Grammar Handbook—your complete guide to mastering English rules and structures.

Key Features:
📖 Grammar Handbook – Learn essential grammar rules with clear explanations and examples to enhance your writing and speaking skills.
📝 Vocabulary Builder – Expand your word bank with curated word lists, flashcards, and review tools.
🔔 Custom Reminders – Get daily notifications for new words or grammar tips to keep learning consistently.
🔥 Streak Tracking – Stay motivated by maintaining your learning streak and reaching new milestones.

Whether you're a student, professional, or language enthusiast, this app is your ultimate companion for mastering English. Start learning today! 🚀

---

# 🤝 Connect with Me

<p align="center">
  <a href="https://github.com/laidat123-png">
    <img src="https://img.shields.io/badge/GitHub-000?logo=github&logoColor=white" height="30" alt="GitHub">
  </a>
  <a href="https://www.facebook.com/dat.laizz?locale=vi_VN">
    <img src="https://img.shields.io/badge/Facebook-1877F2?logo=facebook&logoColor=white" height="30" alt="Facebook">
  </a>
</p>

## Required Environment

### Framework
- [Flutter SDK >= 3.27.0](https://flutter.dev/docs/get-started/install)
- [Dart SDK >= 3.6.0](https://dart.dev/get-dart)

### Android
- [Android Studio >= Ladybug](https://developer.android.com/studio)
- [Android SDK](https://developer.android.com/studio)

### iOS
- [Xcode >= 15.0](https://developer.apple.com/xcode/)
- [Cocoapods >= 1.16.2](https://cocoapods.org)

## Should Have Android Studio Plugins
- Flutter
- Dart
- FlutterAssetsGenerator
- Bloc

## Folder structure
- `assets`: The folder to store resources file such as fonts, images and lottie animations
    - `images`: store images
    - `sounds`: store sounds
    - `fonts`: store fonts
- `lib`: The folder is main container of all code inside Zeniuz application
    - `configs`: Configuration of Router, Supabase, etc.
    - `constants`: Constants of application
    - `core`: Base classes, extensions, etc.
    - `data`:
        - `data_sources`: Data sources such as API, Database, realtime, etc.
        - `models`: Data models convert from raw data to entity
        - `repositories`: Repositories to interact with data sources
    - `gererared`: Generated files (intl, assets, etc.)
    - `navigation`: Navigation of application
    - `ui`: User interface
        - `commons`: Common and base widgets
        - `screens`:
            - `home`:
                - `bloc`: Join screen bloc
                - `widgets`: Widgets of Join screen
                - `home_screen.dart`: Join screen
    - `utils`: Helper functions
    - `main.dart`: Entry point of application
    - `app.dart`: Wrapper of application

## Code style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart/style)
- Import from dart package first, then flutter package, then project package, then current package
- Importing from the same package should be in one line and use relative path
    - ex: `import '../../models/user_model.dart'`

## Usage

### Install dependencies
- Move to root dir `cd {root}`
- Install necessary packages `flutter pub get`

### Generate files
- Generate necessary files: `flutter pub run build_runner build --delete-conflicting-outputs`
- Click `Build` -> `Generate Flutter Assets` to generate assets path
- Note: If you create a new assets folder, right-click on the folder and click `Flutter: Configuring Paths` to add assets path into `pubspec.yaml`

### Add Google Services
- Download `google-services.json` from Firebase and put it in `android/app/src/development` folder
- Download `GoogleService-Info.plist` from Firebase and put it in `ios/Runner/GoogleServices` folder, then rename it to `GoogleService-Info-Development.plist`
- Do the same for `production` flavor



