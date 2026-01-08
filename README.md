# EduHub Cloud

EduHub Cloud is a comprehensive educational management platform built with Dart and Flutter. It provides institutions, teachers, and students with a unified environment to manage assignments, track events, access policies, and stay productive.

## Key Features

- **Dashboard**: A centralized hub for quick access to courses, tasks, and announcements.
- **Policies & Resources**: Access important institutional policies and resources (integrated with Google Docs).
- **Productivity Tools**: Manage personal tasks and assignments efficiently with priority setting and due dates.
- **Announcements**: Stay updated with real-time institutional news.
- **Event Calendar**: Track academic schedules and upcoming events.
- **Authentication**: Secure login via Firebase Auth and Google Sign-In.

## Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (SDK ^3.6.0)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Routing**: [go_router](https://pub.dev/packages/go_router)
- **Backend**: [Firebase](https://firebase.google.com/) (Auth, Firestore, Storage)
- **Integrations**: Google APIs (Drive, Docs, Sheets)

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- A Firebase project configured for the app.

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/Dev-Syndicate/eduhub-cloud.git
    cd eduhub-cloud
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the application**:
    ```bash
    flutter run
    ```
    To run on web specifically:
    ```bash
    flutter run -d chrome
    ```

## Web & OAuth

This project includes public web pages suitable for OAuth consent verification:
- **Home**: `/landing`
- **Privacy Policy**: `/privacy-policy`
- **Terms of Service**: `/terms-of-service`

These routes are accessible without authentication.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
