# Mobile Developer Agent — TennisBnB

## Mission
Build production-ready Flutter mobile app with clean architecture.

## Project Spec
Read `SPEC.md` for full requirements.

## Tech Stack
- Flutter 3.24+
- Dart
- Riverpod (state management)
- Dio or http (networking)
- flutter_secure_storage (token storage)

## Clean Architecture Structure
```
lib/
├── core/
│   ├── constants/       # API endpoints, colors
│   ├── theme/           # App theme
│   └── utils/           # Date formatters, validators
├── data/
│   ├── datasources/     # Remote data sources
│   ├── models/          # JSON serialization
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Business objects
│   ├── repositories/    # Abstract interfaces
│   └── usecases/       # Business logic
└── presentation/
    ├── providers/       # Riverpod providers
    ├── screens/         # Full screens
    └── widgets/        # Reusable widgets
```

## API Base URL
```
http://localhost:8000/api/v1
```

## Authentication Flow
1. PhoneLoginScreen: User enters phone → POST /auth/send-otp
2. OtpVerifyScreen: User enters OTP → POST /auth/verify-otp
3. Receive Bearer token → store securely
4. All subsequent requests include `Authorization: Bearer {token}`

## Screens (in order)

### 1. PhoneLoginScreen
- Phone input field (+country code)
- "Send OTP" button
- Loading state
- Error handling

### 2. OtpVerifyScreen
- 6-digit OTP input (individual boxes)
- Timer showing OTP expiry (5 min)
- Resend OTP button (if expired)
- Verify button
- Auto-submit on complete

### 3. CourtListScreen
- List of courts (CardView)
- Each card: name, location, price, surface
- Pull-to-refresh
- Tap → CourtDetailScreen

### 4. CourtDetailScreen
- Court info (name, location, description, price)
- Availability calendar (week view)
- Selected date time slots
- "Book" button

### 5. BookingCreateScreen (can be part of CourtDetail)
- Date picker
- Time slot picker
- Selected court summary
- Confirm booking button
- Loading + success/error states

### 6. MyBookingsScreen
- Tab: Upcoming / Past
- List of bookings with status chips
- Swipe to cancel (or cancel button)

### 7. BookingDetailScreen
- Court name
- Date & time
- Status badge
- Cancel button (if active)

## Data Models

### Court (from API)
```dart
class Court {
  final int id;
  final String name;
  final String location;
  final String? description;
  final double? pricePerHour;
}
```

### Booking (from API)
```dart
class Booking {
  final int id;
  final int courtId;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // pending, confirmed, cancelled
  final Court? court;
}
```

### Auth Response
```dart
class AuthResponse {
  final String token;
  final User user;
}
```

## State Management (Riverpod)

### Providers
```dart
// Auth
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>

// Courts
final courtsProvider = FutureProvider<List<Court>>
final courtDetailProvider = FutureProvider.family<Court, int>

// Bookings
final myBookingsProvider = FutureProvider<List<Booking>>
```

## Git Protocol
1. Work in mobile/ directory
2. flutter pub get after any pubspec.yaml change
3. Commit with clear messages
4. Push to `maksakoviliya/tennisbnb`

## Commands
```bash
cd /root/.openclaw/workspace/tennisbnb/mobile
flutter pub get
flutter run
flutter build apk --release
```
