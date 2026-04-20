# TennisBnB — Multi-Agent Development Team

## Overview
Production-ready tennis court booking platform.

## Project Spec
**Read `SPEC.md` first** — contains full technical specification.

## Tech Stack
| Component | Technology |
|-----------|------------|
| Backend | Laravel 13 |
| Admin | Filament 5 |
| Mobile | Flutter |
| Database | MySQL |
| API Auth | Laravel Sanctum (OTP) |

## Team

### backend-dev
**Focus:** Laravel 13 backend, API v1, Filament 5 admin, Services, Migrations

Key tasks:
- Upgrade to Laravel 13 (currently 11)
- Implement AuthService (OTP flow)
- Implement BookingService (collision prevention)
- Create API controllers + routes
- Set up Filament 5 resources
- Write unit tests

### mobile-dev
**Focus:** Flutter app, Clean Architecture, Riverpod state management

Key tasks:
- Set up Clean Architecture structure
- Implement OTP authentication flow
- Create all screens (7 screens)
- Implement booking flow
- Connect to API
- State management with Riverpod

### devops
**Focus:** Docker, CI/CD, Production deployment

Key tasks:
- Review/fix Dockerfile for Laravel 13
- Set up GitHub Actions CI/CD
- Configure production Nginx + SSL
- Environment management

## Repository
```
https://github.com/maksakoviliya/tennisbnb
```

## Quick Start

### Backend
```bash
cd tennisbnb/backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan serve
```

### Mobile
```bash
cd tennisbnb/mobile
flutter pub get
flutter run
```

### Docker (production)
```bash
cd tennisbnb
docker compose -f docker/production/docker-compose.yml up -d
```

## Important Notes

### Authentication
- Mobile users: **Phone + OTP only** (no passwords)
- Admin users: **Email + Password** (Filament default)

### Timezone
- All datetimes stored in **UTC**
- Display in user's local timezone

### Booking Collision
- Prevented at **database level** (unique index)
- Also checked at **service level** (SELECT FOR UPDATE)

## Communication
Each agent works in their workspace directory:
- `team/backend-dev/` — Backend context
- `team/mobile-dev/` — Mobile context
- `team/devops/` — DevOps context

Use `sessions_spawn` to create sub-agents for specific tasks.
