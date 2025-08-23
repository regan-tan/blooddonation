# Bloodline SG

A peer-led blood donation app for Singapore youths aged 16-25, built with Flutter. The app creates "Bloodline" challenges between friends to build sustainable blood donation chains and save lives together.

## Features

### 🩸 Bloodline Challenges
- **1-v-1 Challenges**: Create blood donation challenges with friends
- **Streak System**: Build donation chains that must continue within 30 days
- **Nominations**: Invite friends to keep your chain alive between your eligible donation windows
- **Achievement Sharing**: Share your impact with customizable banners

### 🏥 Blood Centre Integration  
- **HSA Centre Data**: Real-time information from Singapore's Health Sciences Authority
- **Centre Locator**: Find nearby blood banks and mobile drives
- **Opening Hours**: Check availability and plan your visit
- **Booking System**: Create group appointments with friends

### 📅 Group Booking & Calendar
- **Group Appointments**: Book timeslots together with friends
- **RSVP Management**: Track who's attending your group booking
- **Calendar Integration**: Add appointments to iOS/Android calendars
- **Smart Reminders**: 24-hour and 2-hour notifications

### 🔐 Authentication & Safety
- **Firebase Auth**: Secure sign-in with Apple, Google, or email
- **HSA Guidelines**: Built-in reminders about donation intervals
- **Age Verification**: Special handling for 16-17 year olds (parental consent)
- **Privacy First**: Opt-in data sharing and transparent privacy controls

## Technology Stack

- **Framework**: Flutter 3.x
- **Language**: Dart 3.x (no TypeScript)
- **Backend**: Firebase (Auth, Firestore, Dynamic Links, Analytics)
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Data Models**: Freezed + JSON Serializable
- **Local Storage**: Flutter Secure Storage
- **Notifications**: Flutter Local Notifications
- **Calendar**: Add 2 Calendar
- **Location**: Geolocator + Google Maps Flutter (optional)

## Project Structure

```
lib/
├── app.dart                 # Main app widget
├── main.dart               # App entry point
├── router.dart             # Navigation configuration
├── firebase_options.dart   # Firebase configuration
├── core/
│   ├── theme/
│   │   └── app_theme.dart  # App theming
│   ├── utils/
│   │   └── deep_link_handler.dart  # Deep link processing
│   └── widgets/
│       └── main_navigation.dart    # Bottom navigation
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_repository.dart
│   │   ├── domain/
│   │   │   └── user_profile.dart
│   │   └── presentation/
│   │       ├── sign_in_page.dart
│   │       └── profile_page.dart
│   ├── centres/
│   │   ├── data/
│   │   │   └── centres_repository.dart
│   │   ├── domain/
│   │   │   └── donation_centre.dart
│   │   └── presentation/
│   │       ├── centres_list_page.dart
│   │       └── centre_detail_page.dart
│   ├── booking/
│   │   ├── data/
│   │   │   └── booking_repository.dart
│   │   ├── domain/
│   │   │   └── group_booking.dart
│   │   └── presentation/
│   │       ├── booking_create_page.dart
│   │       ├── booking_detail_page.dart
│   │       └── my_bookings_page.dart
│   ├── bloodline/
│   │   ├── data/
│   │   │   ├── bloodline_repository.dart
│   │   │   └── codes_repository.dart
│   │   ├── domain/
│   │   │   ├── bloodline_challenge.dart
│   │   │   ├── donation_event.dart
│   │   │   ├── nomination.dart
│   │   │   └── valid_code.dart
│   │   ├── application/
│   │   │   ├── streak_service.dart
│   │   │   └── nomination_service.dart
│   │   └── presentation/
│   │       ├── bloodline_home_page.dart
│   │       ├── challenge_create_page.dart
│   │       ├── challenge_detail_page.dart
│   │       └── code_verify_page.dart
│   └── notifications/
│       └── local_notifications.dart
├── state/
│   └── providers.dart      # Riverpod providers
├── assets/
│   └── centres/
│       └── centres_seed.json  # HSA centre data
└── tooling/
    └── scrape_centres.dart    # HSA data scraper
```

## 🚀 Quick Start

### Prerequisites
- Flutter 3.5+ 
- Dart 3.9+
- Firebase project with Firestore, Auth, and Dynamic Links enabled
- Android Studio / Xcode for mobile development

### 1. Clone and Install Dependencies
```bash
git clone https://github.com/YOUR_USERNAME/bloodline_sg.git
cd bloodline_sg
flutter pub get
```

### 2. Follow Setup Instructions
See [SETUP.md](SETUP.md) for detailed Firebase configuration and setup steps.

### 2. Firebase Setup

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create new project named "bloodline-sg"
3. Enable authentication, Firestore, and Dynamic Links

#### Configure Firebase for Flutter
1. Install Firebase CLI: `npm install -g firebase-tools`
2. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
3. Login to Firebase: `firebase login`
4. Configure project: `flutterfire configure --project=bloodline-sg`

#### Update Firebase Options
Replace placeholder values in `lib/firebase_options.dart` with your project's configuration.

#### Authentication Setup
Enable the following sign-in methods in Firebase Console:
- Email/Password
- Google (configure SHA-1 for Android)
- Apple (iOS only)

#### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Centres are readable by all authenticated users
    match /centres/{centreId} {
      allow read: if request.auth != null;
    }
    
    // Challenges - users can read challenges they participate in
    match /challenges/{challengeId} {
      allow read, write: if request.auth != null && 
        (resource.data.userAUid == request.auth.uid || 
         resource.data.userBUid == request.auth.uid);
    }
    
    // Bookings - users can read bookings they're invited to
    match /group_bookings/{bookingId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in resource.data.attendees;
    }
    
    // Other collections with appropriate security rules...
  }
}
```

#### Dynamic Links Setup
1. Go to Firebase Console > Dynamic Links
2. Set up domain: `bloodlinesg.page.link` 
3. Configure iOS/Android app associations

### 3. Generate Centre Data
```bash
# Run the HSA centre scraper
dart tooling/scrape_centres.dart
```

### 4. Build and Run
```bash
# Generate code files
flutter packages pub run build_runner build

# Run on device/simulator  
flutter run
```

### 5. Platform-Specific Setup

#### iOS Configuration
Update `ios/Runner/Info.plist`:
```xml
<!-- Calendar Access -->
<key>NSCalendarsUsageDescription</key>
<string>Add blood donation appointments to your calendar</string>

<!-- Location Access (optional) -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>Find nearby blood donation centres</string>

<!-- Camera for QR scanning -->
<key>NSCameraUsageDescription</key>
<string>Scan donation verification codes</string>

<!-- Firebase Dynamic Links -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>bloodlinesg.page.link</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>https</string>
        </array>
    </dict>
</array>
```

#### Android Configuration  
Update `android/app/src/main/AndroidManifest.xml`:
```xml
<!-- Permissions -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_CALENDAR" />
<uses-permission android:name="android.permission.READ_CALENDAR" />

<!-- Notification channels -->
<application>
    <activity android:name=".MainActivity" android:exported="true">
        <!-- Dynamic Links intent filter -->
        <intent-filter android:autoVerify="true">
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <category android:name="android.intent.category.BROWSABLE" />
            <data android:scheme="https"
                  android:host="bloodlinesg.page.link" />
        </intent-filter>
    </activity>
</application>
```

## Environment Variables & Keys

Create `.env` file (ignored by git):
```
# Firebase (auto-generated by flutterfire)
FIREBASE_PROJECT_ID=bloodline-sg

# Google Maps (optional)
GOOGLE_MAPS_API_KEY_ANDROID=your_android_maps_key
GOOGLE_MAPS_API_KEY_IOS=your_ios_maps_key

# HSA Scraping (if needed)
HSA_API_KEY=your_hsa_api_key
```

## Key Features Implementation

### Bloodline Streak Logic
- Chain events occur when any participant or nominee donates within 30 days
- Streak increments with each verified donation
- System enforces HSA donation intervals (12-16 weeks)
- Friends/nominees keep chains alive between user's eligible windows

### Code Verification System  
- Staff generate unique codes at donation centres
- Codes are single-use and expire after 24 hours
- Firestore transactions ensure atomicity
- Verification triggers streak updates and notifications

### Group Booking Flow
1. User selects centre and date/time
2. Creates booking with initial attendees
3. Generates shareable invitation link
4. Friends RSVP via the link
5. Calendar reminders are scheduled
6. 24h and 2h notifications sent

### Data Models
All models use Freezed for immutability and JSON serialization:
- `UserProfile`: user information and stats
- `DonationCentre`: HSA centre data with hours
- `BloodlineChallenge`: 1-v-1 challenge state
- `GroupBooking`: appointment details and RSVPs
- `DonationEvent`: verified donation records

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests  
```bash
flutter drive --target=test_driver/app.dart
```

### Golden Tests (UI)
```bash
flutter test --update-goldens
```

## Production Considerations

### Performance
- Implement pagination for large lists
- Cache centre data locally
- Optimize image loading and maps
- Use proper loading states

### Security  
- Validate all user inputs
- Implement rate limiting
- Secure API endpoints
- Regular security audits

### Monitoring
- Firebase Analytics events
- Crashlytics for error tracking
- Performance monitoring
- User feedback collection

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Quick Start
1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

### Development Setup
See [GITHUB_SETUP.md](GITHUB_SETUP.md) for repository setup and development workflow.

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` before committing
- Format code with `dart format .`
- Add documentation for public APIs

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For technical support or feature requests:
- Create an issue on GitHub
- Email: support@bloodlinesg.app
- Documentation: [bloodlinesg.app/docs](https://bloodlinesg.app/docs)

---

**Built with ❤️ for Singapore's youth blood donor community**