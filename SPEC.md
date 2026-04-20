# TennisBnB — Production MVP Specification

**Version:** 1.0  
**Last Updated:** 2026-04-20

---

## 1. TECH STACK

| Component | Technology | Version |
|-----------|------------|---------|
| Backend API | Laravel | 13.x |
| Admin Panel | Filament | 5.x |
| Mobile App | Flutter | 3.24+ |
| Database | MySQL (SQLite for dev) | 8.0 |
| API Auth | Laravel Sanctum | latest |
| Mobile Auth | Phone + OTP | SMS abstracted |

---

## 2. CORE PRODUCT

Booking platform for tennis courts:
- Browse courts
- View real-time availability
- Book time slots
- Cancel bookings
- Admin management via Filament

---

## 3. AUTHENTICATION

### Phone OTP Flow (ONLY method)
```
1. User submits phone number
2. Server generates 6-digit OTP, stores with 5-min expiry
3. SMS sent (mocked in MVP)
4. User submits OTP
5. Server validates: correct code, not expired, not used
6. User created/fetched, Sanctum token issued
```

### OTP Requirements
- 6-digit numeric code
- Expires in 5 minutes
- Single-use (marked as used after verification)
- Rate limited: max 3 requests per phone per 10 minutes

### Admin Auth
- Separate from mobile users
- Email/password via Filament default

---

## 4. DATA MODELS

### User
```
id: bigint (PK)
phone: string (unique)
name: string (nullable)
phone_verified_at: timestamp (nullable)
created_at, updated_at
```

### Court
```
id: bigint (PK)
name: string
location: string
description: text (nullable)
price_per_hour: decimal(8,2) (nullable)
created_at, updated_at
```

### Booking
```
id: bigint (PK)
user_id: bigint (FK → users.id)
court_id: bigint (FK → courts.id)
start_time: datetime (UTC)
end_time: datetime (UTC)
status: enum ['pending', 'confirmed', 'cancelled']
created_at, updated_at

Indexes:
- unique: (court_id, start_time, end_time) — prevents overlaps
- index: (user_id)
- index: (court_id, start_time)
```

### OtpCode
```
id: bigint (PK)
phone: string (indexed)
code: string (6 digits)
expires_at: datetime
used_at: datetime (nullable)
created_at
```

---

## 5. BUSINESS RULES

### Booking Validation
1. `end_time` must be after `start_time`
2. `start_time` must be in the future
3. No overlapping bookings for same court (checked at DB + service level)
4. Use `SELECT FOR UPDATE` to prevent race conditions
5. All times stored in UTC

### Collision Prevention
```sql
-- Check at service level
WHERE court_id = ?
AND status != 'cancelled'
AND (
  (start_time < ? AND end_time > ?) OR  -- new slot overlaps existing
  (start_time >= ? AND start_time < ?) OR  -- new starts during existing
  (end_time > ? AND end_time <= ?)    -- new ends during existing
)
```

### Cancellation
- Cancelled bookings free up time slot immediately
- User can only cancel their own bookings

---

## 6. API ENDPOINTS

### Base URL: `/api/v1`

### Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /auth/send-otp | Send OTP to phone |
| POST | /auth/verify-otp | Verify OTP, get token |

### Courts
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /courts | List all courts |
| GET | /courts/{id} | Court details with availability |

### Bookings
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /bookings | Create booking (auth required) |
| GET | /bookings/my | User's bookings (auth required) |
| POST | /bookings/{id}/cancel | Cancel booking (auth required) |

### Request/Response Format
```json
// Success
{
  "success": true,
  "data": { ... },
  "message": "Operation successful"
}

// Error
{
  "success": false,
  "message": "Error description",
  "errors": { "field": ["validation error"] }
}
```

### Authentication
```
Authorization: Bearer {token}
```

---

## 7. ADMIN PANEL (Filament 5)

### Resources
1. **CourtResource** — CRUD courts
2. **BookingResource** — View, filter by court/date/status, cancel
3. **UserResource** — Read-only user list

### Admin Users
- Created via `php artisan make:filament-user`
- Separate table/guard from mobile users

---

## 8. FLUTTER APP

### Architecture: Clean Architecture
```
lib/
├── core/           # Constants, utils, themes
├── data/           # Repositories impl, data sources, models
├── domain/         # Entities, repository interfaces, use cases
└── presentation/   # Screens, widgets, providers
```

### State Management
- Riverpod (or Bloc)

### Screens
1. **PhoneLoginScreen** — Enter phone, request OTP
2. **OtpVerifyScreen** — Enter OTP, confirm
3. **CourtListScreen** — Browse courts
4. **CourtDetailScreen** — Details + availability calendar
5. **BookingCreateScreen** — Select time slot, confirm
6. **MyBookingsScreen** — List of user's bookings
7. **BookingDetailScreen** — Booking info + cancel button

### API Service
- Base: `http://localhost:8000/api/v1`
- Dio or http package
- Token stored securely (flutter_secure_storage)

---

## 9. DIRECTORY STRUCTURE

### Backend
```
backend/
├── app/
│   ├── Http/
│   │   ├── Controllers/Api/V1/
│   │   │   ├── AuthController.php
│   │   │   ├── CourtController.php
│   │   │   └── BookingController.php
│   │   ├── Requests/Api/V1/
│   │   │   ├── SendOtpRequest.php
│   │   │   ├── VerifyOtpRequest.php
│   │   │   └── CreateBookingRequest.php
│   │   └── Resources/
│   │       ├── CourtResource.php
│   │       └── BookingResource.php
│   ├── Models/
│   │   ├── User.php
│   │   ├── Court.php
│   │   ├── Booking.php
│   │   └── OtpCode.php
│   ├── Services/
│   │   ├── AuthService.php
│   │   └── BookingService.php
│   └── Filament/Resources/
│       ├── CourtResource.php
│       ├── BookingResource.php
│       └── UserResource.php
├── database/migrations/
├── routes/api.php
└── tests/
```

### Flutter
```
mobile/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── theme/
│   │   └── utils/
│   ├── data/
│   │   ├── datasources/
│   │   ├── models/
│   │   └── repositories/
│   ├── domain/
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── usecases/
│   └── presentation/
│       ├── providers/
│       ├── screens/
│       └── widgets/
```

---

## 10. FUTURE EXTENSIONS (Design for these)

- Online payments (Stripe)
- Push notifications (Firebase)
- Multi-club system (organizations table)
- Player matching
- Tournament module
- Dynamic pricing per time slot

---

## 11. KEY ARCHITECTURAL DECISIONS

1. **OTP-only auth** — No passwords, frictionless mobile UX
2. **UTC storage** — Timezone-safe, display in local time
3. **Database-level collision prevention** — Unique index + SELECT FOR UPDATE
4. **Clean separation** — API v1 vs Filament admin
5. **API Resources** — Consistent response formatting
6. **Service layer** — Business logic isolated from controllers
