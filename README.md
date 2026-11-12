# StudyFlow — Student Assignment Planner

StudyFlow is a Flutter-based mobile application designed to help students organize academic assignments, manage deadlines, and track their study progress.

The application connects to a Spring Boot REST API and stores assignment data in a PostgreSQL database. Flutter BLoC is used for state management.

## Features

- **Dashboard:** View assignment statistics, completion progress, and upcoming tasks.
- **Assignment Management:** Create, view, edit, complete, and delete assignments.
- **Deadline Tracking:** Set and update assignment deadlines.
- **Calendar:** View assignments organized by their due dates.
- **Courses:** Automatically group assignments by course and display completion progress.
- **Backend Integration:** Store and retrieve assignments using a REST API.
- **Persistent Storage:** Save assignment data in PostgreSQL.

## Technologies Used

| Component | Technology |
|---|---|
| Mobile Application | Flutter, Dart |
| State Management | Flutter BLoC |
| HTTP Client | Dio |
| Backend | Java, Spring Boot |
| Database | PostgreSQL |
| Database Access | Spring Data JPA / Hibernate |
| API Architecture | REST |

## Project Architecture

StudyFlow follows a client-server architecture.

```text
Flutter Mobile Application
          |
          | HTTP Requests (Dio)
          |
          v
Spring Boot REST API
          |
          | Spring Data JPA
          |
          v
    PostgreSQL
```

The Flutter application uses BLoC to separate business logic from the user interface.

## Main Screens

### Home

Displays an overview of academic tasks, completion statistics, and upcoming assignments.

### Tasks

Allows students to create, edit, complete, and delete assignments.

### Courses

Groups assignments by course and displays the number of completed assignments and overall progress.

### Calendar

Displays assignments according to their deadlines, making it easier to plan academic activities.

## REST API

The backend provides endpoints for assignment management.

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/assignments` | Retrieve assignments |
| POST | `/api/assignments` | Create an assignment |
| PUT | `/api/assignments/{id}` | Update an assignment |
| DELETE | `/api/assignments/{id}` | Delete an assignment |

## How to Run the Project

### Prerequisites

- Flutter SDK
- Android Studio or VS Code
- Java JDK compatible with the project's Spring Boot version
- PostgreSQL
- Maven or the included Maven Wrapper
- Android Emulator or physical Android device

### 1. Clone the Repository

```bash
git clone https://github.com/Zhanetta11/StudyFlow.git
cd StudyFlow
```

### 2. Configure PostgreSQL

Create a PostgreSQL database named:

```text
studyflow_db
```

Configure the database connection in `backend/src/main/resources/application.properties`.

Set the database credentials through environment variables rather than committing passwords to GitHub.

### 3. Start the Backend

Open a terminal in the backend directory:

```bash
cd backend
```

On Windows PowerShell, configure the database credentials:

```powershell
$env:DB_USERNAME = "postgres"
$env:DB_PASSWORD = Read-Host "PostgreSQL password"
```

Start the Spring Boot application:

```powershell
.\mvnw.cmd spring-boot:run
```

The backend runs at:

```text
http://localhost:8081
```

### 4. Start the Flutter Application

Open another terminal in the project root:

```bash
flutter pub get
flutter run
```

For the Android Emulator, the application connects to the backend using:

```text
http://10.0.2.2:8081/api
```

The Spring Boot backend must be running for assignment synchronization to work.

## Testing

Run Flutter static analysis:

```bash
flutter analyze
```

Run Flutter tests:

```bash
flutter test
```

## Future Improvements

- User registration and authentication
- Personal student accounts
- Push notifications for upcoming deadlines
- Course management
- Assignment priority levels
- Advanced academic analytics


## Project Purpose

Developed as a Mid-term Project for the Mobile App Development course.