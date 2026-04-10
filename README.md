# Cipher - QR Utility Application

A comprehensive QR Code utility application built using Flutter, demonstrating core capabilities in device feature integration, secure data handling, and professional UI/UX design.

## Features Implemented

### Core Functionality
*   **Home Dashboard:** Organized layout presenting quick access to scanning, generating, and recent history.
*   **QR Scanner Integration:** Real-time decoding of QR codes utilizing device camera hardware. Supports direct URL routing and actionable deep-linking.
*   **Dynamic QR Generator:** Text, URL, WiFi, and UPI specific data encapsulation into auto-scaled QR generation.
*   **Batch Scanning:** Capability to rapidly scan and queue multiple codes seamlessly.

### Advanced Capabilities
*   **Local Storage & History:** Securely persists scan history using Hive, ensuring data loads immediately upon app reboot.
*   **Gallery Integration:** Extracts and decodes QR patterns from static image files.
*   **Media Exporting:** Generated QR layouts can be rendered into PNG artifacts and shared or saved natively.
*   **Data Portability:** Scanned contents can be copied to the clipboard or exported via native Share interfaces.
*   **History Management:** Track historical scans, clear datasets, and view precise timestamps.

### UI & UX Design
*   **Premium Glassmorphism:** Utilizes advanced backdrop filters and blur effects for an iOS-inspired aesthetic.
*   **Adaptive Dark Theme:** High-contrast dark mode for visibility and premium ergonomics.
*   **Fluid Animations & Feedback:** Staggered UI rendering, contextual transitions, and native haptic feedback.

## Project Setup & Running

### Requirements
*   Flutter SDK (v3.19+)
*   Dart (v3.3+)
*   Android Studio / Xcode for emulators

### Installation

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/Amazingdude1525/Cipher.git
    cd Cipher
    ```

2.  **Fetch Dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the Application:**
    Ensure an emulator is active or a device is connected.
    ```bash
    flutter run
    ```
    To compile a release-level APK:
    ```bash
    flutter build apk --release
    ```

## Screenshots

| Dashboard | Scanner Interface | Code Generator |
| :---: | :---: | :---: |
| <img src="assets/screenshots/home.png" width="230"/> | <img src="assets/screenshots/scanner.png" width="230"/> | <img src="assets/screenshots/generator.png" width="230"/> |
| **History Log** | **Event Management** | **Profile & Settings** |
| <img src="assets/screenshots/history.png" width="230"/> | <img src="assets/screenshots/events.png" width="230"/> | <img src="assets/screenshots/profile.png" width="230"/> |
