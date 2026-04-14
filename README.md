# Restaurant Menu Management API

![Ruby](https://img.shields.io/badge/Ruby-4.0.2-CC342D?style=flat-square&logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/Rails-8.1.3-CC0000?style=flat-square&logo=rubyonrails&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=flat-square&logo=mysql&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-7-DC382D?style=flat-square&logo=redis&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

A RESTful API for managing restaurants and their menu items, built with Ruby on Rails and Redis-backed caching.

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Ruby on Rails 8.1 |
| Language | Ruby 4.0.2 |
| Database | MySQL 8.0 |
| Cache | Redis 7 |
| Authentication | Token-based (custom header token) |
| Pagination | Kaminari |
| Testing | RSpec |
| Containerization | Docker + Compose |

## Requirements

**Using Docker (recommended):**
- Docker >= 24.x
- Docker Compose >= 2.x

**Without Docker:**
- Ruby 4.0.2
- Bundler
- MySQL 8.x
- Redis 7.x

## Setup Instructions

### Using Docker — Recommended

```bash
# Clone the repository
git clone https://github.com/fr-wawan/menu-management-api-ruby
cd menu-management-api-ruby

# Copy environment file
cp .env.example .env

# Start containers
docker compose up -d

# Install gems
docker compose exec api bundle install

# Setup database (create, migrate, seed)
docker compose exec api bundle exec rails db:prepare
docker compose exec api bundle exec rails db:seed
```

The API will be available at: **http://localhost:3000**

### Local Development (Without Docker)

```bash
# Clone the repository
git clone https://github.com/fr-wawan/menu-management-api-ruby
cd menu-management-api-ruby

# Copy environment file
cp .env.example .env

# Install gems
bundle install

# Setup database (create, migrate, seed)
bundle exec rails db:prepare
bundle exec rails db:seed

# Start the server
bundle exec rails server

# Run tests
bundle exec rspec
```

## API Documentation

### Postman Collection

1. Import `Menu Management API Ruby.postman_collection.json` into Postman
2. Import `Menu Management API.postman_environment.json` as environment
3. Select the **"Menu Management API"** environment
4. Run **Register** or **Login** first — the token will be automatically saved

### Base URL

```
http://localhost:3000/api/v1
```

### Authentication

Write operations require a token in the `Authorization` header:

```
Authorization: Bearer <token>
```

#### Register

```http
POST /api/v1/auth/register
Content-Type: application/json

{
  "user": {
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }
}
```

#### Login

```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "user": {
    "email": "john@example.com",
    "password": "password123"
  }
}
```

**Response:**

```json
{
  "message": "Login successful",
  "token": "<token>",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "created_at": "2026-04-14T10:20:30.000Z"
  }
}
```

#### Logout (Requires Auth)

```http
DELETE /api/v1/auth/logout
Authorization: Bearer <token>
```

### Restaurants

| Method | Endpoint | Auth Required | Description |
|--------|----------|:---:|-------------|
| GET | `/restaurants` | ✗ | List all restaurants (cached + paginated) |
| GET | `/restaurants/{id}` | ✗ | Get restaurant with menu items (cached) |
| POST | `/restaurants` | ✓ | Create a restaurant |
| PUT | `/restaurants/{id}` | ✓ | Update a restaurant |
| DELETE | `/restaurants/{id}` | ✓ | Delete a restaurant |

#### Query Parameters — `GET /restaurants`

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `page` | integer | 1 | Page number |
| `search` | string | — | Search by restaurant name |

#### Create Restaurant

```http
POST /api/v1/restaurants
Authorization: Bearer <token>
Content-Type: application/json

{
  "restaurant": {
    "name": "Pizza Palace",
    "address": "123 Main Street",
    "phone": "+62-812-3456-7890",
    "opening_hours": "09:00 - 22:00"
  }
}
```

### Menu Items

| Method | Endpoint | Auth Required | Description |
|--------|----------|:---:|-------------|
| GET | `/restaurants/{id}/menu_items` | ✗ | List menu items (paginated) |
| POST | `/restaurants/{id}/menu_items` | ✓ | Add a menu item |
| PUT | `/menu_items/{id}` | ✓ | Update a menu item |
| DELETE | `/menu_items/{id}` | ✓ | Delete a menu item |

#### Query Parameters — `GET /restaurants/{id}/menu_items`

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `category` | string | — | Filter by category: `appetizer`, `main`, `dessert`, `drink` |
| `search` | string | — | Filter by menu item name |
| `page` | integer | 1 | Page number |

#### Create Menu Item

```http
POST /api/v1/restaurants/1/menu_items
Authorization: Bearer <token>
Content-Type: application/json

{
  "menu_item": {
    "name": "Spring Rolls",
    "description": "Crispy vegetable spring rolls",
    "price": 8.99,
    "category": "appetizer",
    "is_available": true
  }
}
```

### Response Format

Success responses return the resource JSON directly. Errors return an `error` or `errors` payload.

**Error:**

```json
{
  "errors": ["Validation message here"]
}
```

### HTTP Status Codes

| Code | Meaning |
|------|---------|
| 200 | OK — request succeeded |
| 201 | Created — resource created |
| 401 | Unauthorized — missing or invalid token |
| 404 | Not Found — resource does not exist |
| 422 | Unprocessable Content — validation failed |

## Design Decisions

### 1. Redis-backed Caching
Restaurant listing and detail responses are cached via `Rails.cache` to reduce load on frequently accessed endpoints. Cache is invalidated after restaurant updates.

### 2. Token-based Authentication
Authentication is handled via a per-user token stored in the database and passed in the `Authorization` header. Read-only endpoints remain public.

### 3. Simple, RESTful Routing
Creation uses nested routes for menu items, while update/delete are shallow (`/menu_items/{id}`) for concise URLs.

### 4. Pagination and Filtering
List endpoints use Kaminari pagination; menu items also support category and name filtering.

### 5. Data Integrity
Restaurant deletion cascades to menu items to maintain referential integrity.

### 6. Rate Limiting
Auth endpoints (`/api/v1/auth/*`) are rate-limited by IP to reduce brute-force abuse, and a global per-IP limit protects the rest of the API. In non-test environments, Rack::Attack uses Redis for shared counters.

## Running Tests

```bash
bundle exec rspec
```

### Running Tests with Docker

```bash
docker compose exec -e RAILS_ENV=test api bin/rails db:create db:schema:load
docker compose exec -e RAILS_ENV=test api rspec
```

Or use the helper script:

```bash
bin/rspec
```

## Project Structure

```
app/
├── controllers/
│   └── api/v1/
│       ├── auth/registrations_controller.rb
│       ├── auth/sessions_controller.rb
│       ├── menu_items_controller.rb
│       └── restaurants_controller.rb
├── models/
│   ├── menu_item.rb
│   ├── restaurant.rb
│   └── user.rb
```

## License

This project is open-sourced software licensed under the [MIT license](LICENSE).
