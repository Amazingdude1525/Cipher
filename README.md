# Cipher - QR Utility Application

A comprehensive QR Code utility application built using Flutter. This project was developed as part of the iOS Club Task Round, demonstrating core capabilities in device feature integration, secure data handling, and professional UI/UX design.

## Features Implemented

### Core Functionality
*   **Home Dashboard:** Organized layout presenting quick access to scanning, generating, and recent history.
*   **QR Scanner Integration:** Real-time decoding of QR codes utilizing device camera hardware. Supports direct URL routing and actionable deep-linking when compatible formats are detected.
*   **Dynamic QR Generator:** Text, URL, WiFi, and UPI specific data encapsulation into auto-scaled QR generation.
*   **Batch Scanning:** Capability to rapidly scan and queue multiple codes seamlessly without interrupting the viewfinder flow.

### Advanced Capabilities (Bonus Implementation)
*   **Local Storage & History:** Securely persists scan history using Hive (Fast key-value local database), ensuring data loads immediately upon app reboot.
*   **Gallery Integration:** Extracts and decodes QR patterns from static image files saved in local device storage.
*   **Media Exporting:** Generated QR layouts can be directly rendered into PNG artifacts and shared or saved natively to Android/iOS storage systems.
*   **Data Portability:** Scanned contents can be securely copied to the system clipboard or exported via native Share interfaces.
*   **History Management:** Users can track historical scans, clear datasets locally, and view precise timestamps for interaction events.

### UI & UX Design
*   **Premium Glassmorphism:** Utilizes advanced backdrop filters and blur effects to create an iOS-inspired frosted glass aesthetic.
*   **Adaptive Dark Theme:** The application strictly enforces a high-contrast dark mode to improve scan visibility, device battery efficiency, and premium ergonomics.
*   **Fluid Animations & Feedback:** Implements staggered UI rendering, contextual page transitions, and native haptic feedback for user interactions (e.g., successful scan confirmation).

## Project Setup & Running

### Requirements
*   Flutter SDK (v3.19+ recommended)
*   Dart (v3.3+ recommended)
*   Android Studio / Xcode for emulators

### Installation

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/Amazingdude1525/Cipher-Developers-Team-Task-Round.git
    cd Cipher-Developers-Team-Task-Round
    ```

2.  **Fetch Dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the Application:**
    Ensure an emulator is active or a device is connected organically via USB/Wi-Fi debugging.
    ```bash
    flutter run
    ```
    To compile a release-level APK:
    ```bash
    flutter build apk --release
    ```

## Screenshots

*(Note: Participants should place screenshot image files directly into the `/assets/screenshots` folder and the markdown below will render them.)*

| Dashboard | Scanner Interface | Code Generator |
| :---: | :---: | :---: |
| <img src="assets/screenshots/home.png" width="230"/> | <img src="assets/screenshots/scanner.png" width="230"/> | <img src="assets/screenshots/generator.png" width="230"/> |
| **History Log** | **Event Management** | **Custom Interface** |
| <img src="assets/screenshots/history.png" width="230"/> | <img src="assets/screenshots/events.png" width="230"/> | <img src="assets/screenshots/custom.png" width="230"/> |

## Demonstration Video

[Link to Demonstration Video] *(Insert your hosted video URL (e.g., YouTube/Google Drive) here)*

---
*Built for the iOS Club Developers Team Task Round.*
