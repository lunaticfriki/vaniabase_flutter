# Vaniabase Flutter

Vaniabase is a collection management application built with Flutter. It provides a comprehensive dashboard to track, organize, and manage various resources (items, categories, authors, topics, tags) using a sleek, custom cyberpunk-inspired design.

## Features

- **Dashboard Overview:** Get a quick glance at statistics (total categories, authors, topics, tags) and recently added items.
- **Item Management:** Add, edit, and delete items. Each item can have a cover image, description, tags, topic, and category.
- **Organized Lists:** Browse items filtered by Category, Author, Topic, or Tag.
- **Cyberpunk Aesthetics:** A unique, dark-mode exclusive UI featuring vibrant neon accents, custom cut-edge shapes, dynamic gradients, and modern typography (Inconsolata).
- **Authentication:** Secure Google Sign-In integration for personalized access.
- **Cloud Sync:** Real-time data persistence and image upload/storage using Firebase Firestore and Firebase Storage.

## Tech Stack

- **Framework:** Flutter
- **State Management:** `flutter_bloc` (Cubit)
- **Dependency Injection:** `get_it`
- **Routing:** `go_router`
- **Backend:** Firebase (Auth, Firestore, Storage)
- **Styling:** Custom theme with Google Fonts

## Architecture Overview

This project is built following **Domain-Driven Design (DDD)** and **Hexagonal Architecture** principles. The codebase is organized into four main layers to ensure separation of concerns, maintainability, and testability.

### 1. Domain Layer (`lib/domain/`)
The core of the application, independent of any UI or external frameworks.
- **Entities:** Core business objects (e.g., `Item`, `Category`).
- **Value Objects:** Immutable objects representing domain concepts (e.g., `Title`, `Id`, `CoverImage`).
- **Repositories Interfaces:** Abstract definitions of data operations (e.g., `IItemsRepository`).

### 2. Infrastructure Layer (`lib/infrastructure/`)
Responsible for external communications and fulfilling domain repository interfaces.
- **Data Sources:** Direct interactions with external services (e.g., Firebase Firestore, Storage).
- **Repositories:** Implementations of the domain repository interfaces, handling data mapping and error translation.

### 3. Application Layer (`lib/application/`)
Orchestrates the business use cases and manages application state.
- **Services:** High-level APIs for reading and writing data (e.g., `ItemsReadService`, `ItemsWriteService`).
- **State Management:** Cubits (`ItemsCubit`, `AuthCubit`) that react to UI events, communicate with services, and emit new states for the presentation layer.

### 4. Presentation Layer (`lib/presentation/`)
The User Interface. It depends only on the Application Layer.
- **Screens:** Complete UI pages (Dashboard, Item Details, etc.).
- **Widgets:** Reusable UI components (e.g., `ItemPreviewWidget`, `MainDrawer`).
- **Router:** Application navigation configuration (`go_router`).
- **Theme:** Design system and styling configurations (`CyberpunkStyling`, `AppTheme`).

### Configuration (`lib/config/`)
Contains app-wide setup, including dependency injection (`sl` via `get_it`) and environment variables.

## Getting Started

### Prerequisites
- Flutter SDK (^3.10.8)
- Firebase project setup (Android/Web configurations)

### Setup
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Ensure Firebase configuration files (`google-services.json` for Android) are correctly placed.
4. Set up your `.env` file if required.
5. Run the app: `flutter run`
