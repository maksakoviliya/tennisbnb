# Backend Developer Agent — TennisBnB

## Mission
Build production-ready Laravel 13 backend with clean architecture.

## Project Spec
Read `SPEC.md` for full requirements. Key points:

## Tech Stack
- Laravel 13 (NOT 11)
- Filament 5 (NOT 3) — check compatibility with Laravel 13
- MySQL (SQLite for dev only)
- Laravel Sanctum for API auth
- PHP 8.3+

## Architecture
```
Controllers (API) → Services → Models
```

## Models
1. **User** — phone (unique), name, phone_verified_at
2. **Court** — name, location, description, price_per_hour
3. **Booking** — user_id, court_id, start_time, end_time, status
4. **OtpCode** — phone, code, expires_at, used_at

## Critical Business Rules
- **NO overlapping bookings** — use unique index + SELECT FOR UPDATE
- All times in UTC
- OTP: 6 digits, 5 min expiry, single-use
- Rate limit: 3 OTP requests per phone per 10 min

## API Routes (/api/v1)
```
POST /auth/send-otp
POST /auth/verify-otp
GET  /courts
GET  /courts/{id}
POST /bookings (auth required)
GET  /bookings/my (auth required)
POST /bookings/{id}/cancel (auth required)
```

## Services to Implement
1. **AuthService**
   - generateOtp(phone): creates OTP, returns code (mock SMS)
   - verifyOtp(phone, code): validates, creates/fetches user, returns Sanctum token
   - rate limit check

2. **BookingService**
   - createBooking(user, data): validates no collision, creates booking
   - cancelBooking(user, bookingId): validates ownership, cancels
   - getUserBookings(user): returns user's bookings
   - checkAvailability(courtId, start, end): checks for conflicts

## Collision Prevention SQL
```php
Booking::where('court_id', $courtId)
    ->where('status', '!=', 'cancelled')
    ->where(function ($q) use ($start, $end) {
        $q->whereBetween('start_time', [$start, $end])
          ->orWhereBetween('end_time', [$start, $end])
          ->orWhere(function ($q2) use ($start, $end) {
              $q2->where('start_time', '<=', $start)
                 ->where('end_time', '>=', $end);
          });
    })->exists();
```

## Filament Resources
- CourtResource (full CRUD)
- BookingResource (read + cancel action)
- UserResource (read-only)

## Commands
```bash
cd /root/.openclaw/workspace/tennisbnb/backend
composer install
php artisan migrate
php artisan serve
php artisan make:filament-user
```

## Git Protocol
1. Work in backend/ directory
2. Commit frequently with clear messages
3. Push to `maksakoviliya/tennisbnb`
