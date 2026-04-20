# TennisBnB 🏀🎾

Booking platform for tennis courts with mobile app and admin panel.

## Stack

- **Backend**: Laravel 11 + FilamentPHP (admin panel)
- **Mobile**: Flutter (iOS/Android)
- **Database**: SQLite (dev) / MySQL (prod)

## Quick Start

### Backend

```bash
cd backend

# Install dependencies
composer install

# Copy environment
cp .env.example .env

# Generate key
php artisan key:generate

# Run migrations
php artisan migrate

# Start server
php artisan serve
```

### Mobile App

```bash
cd mobile

# Get dependencies
flutter pub get

# Run (requires backend running)
flutter run
```

### Admin Panel

After starting the backend:
- URL: `http://localhost:8000/admin`
- Default: creates super admin on first access

## Project Structure

```
tennisbnb/
├── backend/          # Laravel API + Filament admin
│   ├── app/
│   │   ├── Http/Controllers/Api/V1/  # REST API
│   │   └── Models/                   # Eloquent models
│   ├── database/migrations/          # DB schema
│   └── routes/api.php               # API routes
├── mobile/          # Flutter app
│   └── lib/
│       ├── models/    # Data models
│       ├── screens/    # UI screens
│       └── services/  # API service
├── docker-compose.yml
└── README.md
```

## API Endpoints (v1)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/v1/courts | List all courts |
| GET | /api/v1/courts/{id} | Get court details |
| POST | /api/v1/bookings | Create booking |
| GET | /api/v1/bookings/my?email=... | Get user's bookings |
| POST | /api/v1/bookings/{id}/cancel | Cancel booking |

## Features

- [ ] Court listing & details
- [ ] Real-time availability
- [ ] Online booking
- [ ] Booking management (cancel)
- [ ] Admin panel (Filament)
- [ ] Push notifications (future)
- [ ] Payment integration (future)
