# 📱 OCP Formation Manager — Enterprise-Grade HR Intelligence

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-00C853?style=for-the-badge)](https://codewithandrea.com/articles/flutter-presentation-layer/)
[![Database](https://img.shields.io/badge/DB-Hive_NoSQL-FFAB00?style=for-the-badge)](https://pub.dev/packages/hive)
[![License](https://img.shields.io/badge/License-All_Rights_Reserved-red?style=for-the-badge)](LICENSE)

**OCP Formation Manager** is a high-performance, production-ready HR solution designed to bridge the gap between employee professional development and corporate administrative excellence. Built with a "Security-First" mindset and a clean Material 3 design language, it stands as a testament to modern Flutter engineering.

---

## 📸 Preview

<p align="center">
  <img src="lib/AppScreens/splashScreen.png" width="230" alt="Splash Screen"/>
  <img src="lib/AppScreens/loginScreenEmploye.png" width="230" alt="Login"/>
  <img src="lib/AppScreens/employerDashboard.png" width="230" alt="Employee Dashboard"/>
  <img src="lib/AppScreens/inscriptionScreen.png" width="230" alt="Inscription"/>
  <img src="lib/AppScreens/loginScreenRh.png" width="230" alt="HR login"/>
  <img src="lib/AppScreens/rhDashboard.png" width="230" alt="HR Dashboard"/>
  <img src="lib/AppScreens/employesList.png" width="230" alt="Trainings"/>
  <img src="lib/AppScreens/.png" width="230" alt="Attendance"/>  
  <img src="lib/AppScreens/employeInformations.png" width="230" alt="Details"/>
  <img src="lib/AppScreens/newFormation.png" width="230" alt="New Formation"/> 
  <img src="lib/AppScreens/formation.png" width="230" alt="Formations"/>
  <img src="lib/AppScreens/dateLimite.png" width="230" alt="Date limite"/>  
  <img src="lib/AppScreens/presenceDates.png" width="230" alt="Dates"/>    
  <img src="lib/AppScreens/presencePdfFile.png" width="230" alt="PDF Generation"/>
</p>

<p align="center">
  <i>HR Dashboard • Employee Portal • Attendance Tracking • Automated Reporting</i>
</p>

---

## ✨ Features at a Glance

* **🎯 Role-Based Catalogs:** Dynamic training visibility tailored specifically to employee job positions.
* **📈 Progress Orchestration:** Real-time tracking of completed modules with visual progress indicators.
* **📅 Advanced Attendance:** Intelligent multi-date presence management with automated logging for HR.
* **📄 Enterprise Reporting:** Seamless generation of professional **PDF** (individual files) and **Excel** (global analytics).
* **💾 Offline-First Strategy:** Robust local persistence via **Hive NoSQL**, ensuring 100% data availability offline.
* **🔔 Real-time Synergy:** Integrated notification system for direct communication between HR and staff.

---

## 🛡️ Security & Intellectual Property

OCP Formation Manager is built with a rigorous **Security-First** approach to protect corporate data and employee privacy.

* **Encrypted Persistence:** Sensitive user and formation data are stored using secure Hive adapters.
* **Logic Isolation:** Critical HR business rules are strictly contained within the Domain layer.
* **Integrity Checks:** Validation logic for training deadlines and enrollment modifications.
* **Ownership Protection:** All source files are proprietary and protected under a strict "All Rights Reserved" license.

---

## 🏗️ Architecture: The Clean Standard

The codebase follows the **Clean Architecture** pattern, enforcing a strict separation of concerns that ensures the app is decoupled, testable, and maintainable at scale.

### Layer Breakdown
1.  **Presentation Layer:** State-driven UI using Flutter Material 3, **Provider**, and clean UI components.
2.  **Domain Layer (Core):** Pure Dart business logic containing atomic Use Cases and Entity Definitions.
3.  **Data Layer:** Infrastructure implementation, managing local storage via **Hive** and data repositories.

```text
[Presentation (UI)] ──► [Domain (Use Cases)] ──► [Data (Hive/Repos)]
```

---

## 🧰 Tech Stack

* **Framework:** Flutter (Multi-platform Engine)
* **Language:** Dart 3.x
* **State Management:** Provider
* **Database:** Hive (High-performance NoSQL)
* **Reporting:** PDF & Excel Dart Libraries
* **Architecture:** Clean Architecture
* **UI System:** Material 3

---

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (v3.10.0) or newer.
* Dart SDK (v3.0.0) or newer.

### Setup Instructions
1.  **Clone the Repository**
    ```sh
    git clone https://github.com/Douaa0504/OCP_Formation_Manager.git
    ```

2.  **Install Dependencies**
    ```sh
    flutter pub get
    ```

3.  **Build Data Adapters**
    ```sh
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Build and Deploy**
    Sync dependencies and run the project on your target device/emulator.

---

## 📂 Project Structure

```text
├── lib/
│   ├── core/               # Enterprise Themes, Utils & Global Constants
│   ├── data/               # Models, Hive Adapters & Repository Implementation
│   ├── domain/             # Pure Business Logic: Entities & Use Cases
│   ├── presentation/       # UI Logic: Screens (AppScreens), Widgets & Providers
│   └── main.dart           # Application Entry Point
├── AppScreens/             # App preview images & assets
└── LICENSE                 # Legal ownership document
```

---

## 🌍 Localization & Accessibility

Built for professional environments, the app prioritizes accessibility:
* **Responsive Layouts:** Adaptive UI that scales across various tablet and phone densities.
* **I18n Ready:** Architecture prepared for multi-language support (French/English/Arabic).
* **Data Integrity:** Validation systems to prevent input errors during HR data entry.

---

## 📜 License

**Copyright © 2026 Douaa ERRAMI. All Rights Reserved.**

This project is proprietary and confidential, developed as part of a professional internship at OCP. Unauthorized copying, modification, or distribution is strictly prohibited.

---

**Developed by [Douaa ERRAMI](https://github.com/Douaa0504)** — *Specialist in Digital Development & Next-Gen Mobile Solutions.*
⭐ **Star this repository if you find it impressive!**