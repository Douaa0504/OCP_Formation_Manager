# 📱 OCP Formation Manager

### Flutter Application for Employee Training and HR Management

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge\&logo=flutter\&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge\&logo=dart\&logoColor=white)](https://dart.dev/)
[![Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-00C853?style=for-the-badge)](https://codewithandrea.com/articles/flutter-presentation-layer/)
[![State Management](https://img.shields.io/badge/State_Management-Provider-795548?style=for-the-badge)](https://pub.dev/packages/provider)
[![Local Storage](https://img.shields.io/badge/Local_Storage-Hive-FFAB00?style=for-the-badge)](https://pub.dev/packages/hive)

**OCP Formation Manager** is a Flutter application designed to simplify employee training management and HR operations. It provides features for managing training sessions, tracking attendance, accessing employee information, and generating reports in PDF and Excel formats.

The project focuses on organizing HR workflows through a structured application architecture, local data persistence, and a user interface designed for employee and HR use cases.

---

## 📸 Screenshots

The following screenshots showcase the application's main interfaces and features.

<p align="center">
  <img src="lib/AppScreens/splashScreen.png" width="230" alt="Application splash screen"/>
  <img src="lib/AppScreens/loginScreenEmploye.png" width="230" alt="Employee login screen"/>
  <img src="lib/AppScreens/employerDashboard.png" width="230" alt="Employee dashboard"/>
  <img src="lib/AppScreens/inscriptionScreen.png" width="230" alt="Registration screen"/>
</p>

<p align="center">
  <img src="lib/AppScreens/loginScreenRh.png" width="230" alt="HR login screen"/>
  <img src="lib/AppScreens/rhDashboard.png" width="230" alt="HR dashboard"/>
  <img src="lib/AppScreens/employesList.png" width="230" alt="Employee list"/>
  <img src="lib/AppScreens/employeInformations.png" width="230" alt="Employee information"/>
</p>

<p align="center">
  <img src="lib/AppScreens/newFormation.png" width="230" alt="Create a training session"/>
  <img src="lib/AppScreens/formation.png" width="230" alt="Training details"/>
  <img src="lib/AppScreens/dateLimite.png" width="230" alt="Training deadline"/>
  <img src="lib/AppScreens/presenceDates.png" width="230" alt="Attendance dates"/>
</p>

<p align="center">
  <img src="lib/AppScreens/presencePdfFile.png" width="230" alt="PDF attendance report"/>
</p>

<p align="center">
  <i>Employee Portal · HR Dashboard · Training Management · Attendance Tracking · Report Generation</i>
</p>

> **Note:** Make sure the screenshot paths match the actual files in the repository. Remove any image reference that does not exist.

---

## ✨ Features

### 🎯 Training Management

* Display training opportunities according to employee job positions.
* Manage training sessions and their associated information.
* Track training deadlines and relevant dates.

### 👥 Employee Management

* Access employee information through dedicated interfaces.
* Provide separate interfaces for employees and HR users.

### 📅 Attendance Tracking

* Manage attendance across multiple dates.
* Record and consult attendance information through HR interfaces.

### 📄 Report Generation

* Generate PDF reports for individual records.
* Export consolidated data to Excel for reporting and analysis.

### 💾 Local Data Persistence

* Use Hive for local data storage.
* Support access to locally stored information according to the application's existing data flow.

### 🔔 Notifications

* Support notifications related to communication between HR and employees, according to the implemented functionality.

---

## 🏗️ Architecture

The project is organized around **Clean Architecture principles**, separating the user interface, business rules, and data access responsibilities.

### Main Layers

**Presentation Layer**

* Flutter screens and reusable widgets.
* Provider for state management.
* User interactions and presentation logic.

**Domain Layer**

* Business entities and application rules.
* Repository contracts and use cases, where implemented.
* Separation of business concepts from infrastructure details.

**Data Layer**

* Repository implementations.
* Data access and local persistence using Hive.
* Mapping and handling of application data.

### Architecture Overview

```text
┌──────────────────────────────┐
│      Presentation Layer      │
│ Flutter UI · Provider         │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│         Domain Layer         │
│ Entities · Business Rules    │
│ Repository Contracts         │
└──────────────▲───────────────┘
               │
               │ Implements contracts
┌──────────────┴───────────────┐
│          Data Layer          │
│ Repositories · Hive · Models │
└──────────────────────────────┘
```

> The diagram represents the intended separation of responsibilities. The exact implementation depends on the classes and dependencies present in the codebase.

---

## 🧰 Tech Stack

| Technology             | Purpose                                    |
| ---------------------- | ------------------------------------------ |
| **Flutter**            | Cross-platform application development     |
| **Dart**               | Main programming language                  |
| **Provider**           | State management                           |
| **Hive**               | Local NoSQL data persistence               |
| **PDF libraries**      | PDF report generation                      |
| **Excel libraries**    | Spreadsheet export                         |
| **Clean Architecture** | Separation of application responsibilities |
| **Material 3**         | User interface design system               |

The project uses Dart and Flutter packages for its application logic, local persistence, and reporting features.

---

## 📂 Project Structure

The project follows a layered organization. The structure below is a general overview; adjust the paths to match the actual repository.

```text
lib/
├── core/           # Shared utilities, themes and constants
├── data/           # Data models, storage and repositories
├── domain/         # Entities, business rules and contracts
├── presentation/   # Screens, widgets and state management
├── AppScreens/     # Application screenshots, if stored here
└── main.dart       # Application entry point

pubspec.yaml        # Dependencies and project configuration
LICENSE             # License information, if included
```

---

## 🚀 Getting Started

### Prerequisites

Install the following tools before running the project:

* Flutter SDK compatible with the project's dependencies.
* Dart SDK compatible with the installed Flutter version.
* An IDE such as Visual Studio Code or Android Studio.
* An Android emulator, connected device, or another supported target platform.

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/Douaa0504/OCP_Formation_Manager.git
cd OCP_Formation_Manager
```

**2. Install dependencies**

```bash
flutter pub get
```

**3. Generate required files, if applicable**

If the project uses code generation, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This step is only required when generated files need to be created or updated.

**4. Run the application**

```bash
flutter run
```

Follow the Flutter setup instructions for your target platform if additional configuration is required.

---

## Data Handling

The application uses Hive for local data persistence.

Data protection depends on the application's actual storage configuration and implementation. Local persistence alone does not guarantee encryption, and authentication or authorization guarantees should be evaluated according to the mechanisms implemented in the project.

Do not add real employee information, credentials, internal company data, or other confidential material to public repositories.

---

##  Project Context

This project is associated with my professional internship experience at OCP.

It provided an opportunity to work with Flutter and Dart while developing features related to employee training, attendance management, and report generation.

### Technical Areas

* Cross-platform mobile application development.
* State management with Provider.
* Layered application architecture.
* Local persistence with Hive.
* PDF and Excel report generation.
* Form handling and data validation.

---

## 📄 License

Copyright © 2026 Douaa ERRAMI.

All rights reserved, subject to the applicable ownership rights and permissions governing this project.

Do not redistribute proprietary source code, company data, or confidential materials without the necessary authorization.

---

**Developed by Douaa ERRAMI**

*Flutter Mobile Developer · Dart · Cross-Platform Development*

[GitHub Profile](https://github.com/Douaa0504)
