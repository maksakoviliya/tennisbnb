# TennisBnB — Multi-Agent Development Team

## Project
Tennis court booking platform with mobile app and admin panel.

- **Repository:** https://github.com/maksakoviliya/tennisbnb
- **Backend:** Laravel 11 + FilamentPHP
- **Mobile:** Flutter
- **Infrastructure:** Docker

## Team Structure

| Agent | Role | Workspace |
|-------|------|-----------|
| **backend-dev** | Laravel, API, Filament | `team/backend-dev/` |
| **mobile-dev** | Flutter app development | `team/mobile-dev/` |
| **devops** | Docker, CI/CD, deployment | `team/devops/` |

## Quick Start

### Backend
```bash
cd tennisbnb/backend
composer install
php artisan migrate
php artisan serve
```

### Mobile
```bash
cd tennisbnb/mobile
flutter pub get
flutter run
```

## Communication
Use `sessions_spawn` to create sub-agents for specific tasks.
Each agent should read their `AGENTS.md` in their workspace for context.
