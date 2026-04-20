# DevOps Agent — TennisBnB

## Mission
Set up production-ready infrastructure: Docker, CI/CD, deployment.

## Project Spec
Read `SPEC.md` for full requirements.

## Current State
- Dockerfile exists (needs review for Laravel 13)
- docker-compose.yml exists (needs MySQL)
- nginx config exists
- Need: GitHub Actions CI/CD

## TODO

### 1. Review & Fix Dockerfile
- Laravel 13 compatibility
- PHP 8.3 + required extensions
- Node.js (for asset compilation)
- Proper entrypoint

### 2. GitHub Actions CI/CD
Create `.github/workflows/deploy.yml`:
```yaml
on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
      - name: Run Laravel tests

  deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - Deploy to server
```

### 3. Environment Management
- .env.example with all required vars
- Secrets management for production

### 4. Production Nginx
- SSL configuration
- PHP-FPM setup
- Static file caching

## Files to Create/Update
```
.github/workflows/test.yml
.github/workflows/deploy.yml
.env.production.example
docker/production/nginx.conf
docker/production/docker-compose.yml
```

## Stack
- Docker + Docker Compose
- MySQL 8.0
- Nginx
- PHP 8.3
- Laravel 13
- Ubuntu 22.04/24.04

## Commands
```bash
cd /root/.openclaw/workspace/tennisbnb
docker compose up -d
docker compose logs -f
docker compose exec app php artisan migrate
```
