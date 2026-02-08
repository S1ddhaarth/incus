# Voice-Controlled Anesthesia Workstation

A voice-activated intelligent anesthesia workstation with embedded control and safety systems, designed to reduce clinician distraction and increase response speed in critical surgical environments.

# Project Overview

A hybrid voice + physical anesthesia control console suitable for real-time clinical environments. This prototype demonstrates a closed-loop control system that automates anesthetic drug delivery monitoring using real-time feedback while enforcing strict safety constraints through voice commands and manual overrides.

This project was developed as part of the **TinkerHub 24-Hour Hackathon (Jan 31 – Feb 1)**.

---

## 🧠 Problem Statement

During surgery, anesthesiologists continuously manage drug delivery, ventilator settings, monitoring alarms, and documentation — often while their hands are occupied and attention is divided.

Most current anesthesia workstations rely on manual knobs, touchscreens, and physical interfaces, which can slow response times and increase cognitive load during critical moments.

A voice-controlled system, combined with context-aware AI and hard safety constraints, can enable faster, hands-free interaction without compromising control or safety.

---

## 🎯 Objectives

- **Voice-Activated Control**: Respond accurately to voice commands in noisy OT environments.
- **Hardware Integration**: Control anesthesia-related hardware (simulated via ESP32 & Servos).
- **Safety First**: Enforce hard-coded safety limits and priority-based control logic.
- **Real-time Monitoring**: Continuous monitoring of physiological parameters (HR, SpO₂, BP).
- **Hybrid Interface**: Preserve full manual control alongside voice commands.

---

## ⚙️ System Architecture

The system consists of three main intelligent components working in tandem:

1.  **Voice Command Center (Python GUI)**:
    -   Acts as the central control unit.
    -   Uses Speech Recognition to parse commands like "increase oxygen", "critical mode", etc.
    -   Sends control signals to the ESP32 via HTTP requests.
    -   Provides a visual dashboard of logs and system status.

2.  **Hardware Control Unit (ESP32)**:
    -   Host a web server to receive commands from the Python GUI.
    -   Controls physical actuators (LEDs representing valves/alarms).
    -   Fetches real-time patient vitals (Breathing Rate, SpO₂, Glucose, BP) from a Firebase Realtime Database.
    -   Logs actions to internal memory.

3.  **Patient Data Simulator (Flutter App)**:
    -   Simulates a patient monitor.
    -   Generates and displays physiological data.
    -   (Conceptually) Pushes data to the cloud for the ESP32 to react to.

---

## 🧩 Hardware Components

-   **ESP8266/ESP32**: Main microcontroller.
-   **Microphone**: For voice command input (connected to PC).
-   **LED Indicators**: Visual feedback for "Blood Flow" or "Alarms".
-   **PC/Laptop**: Runs the Python Control Center and Flutter Simulator.

---

## 💻 Software Implementation

### 1. Python Control Center (`Sketch and GUI/GUI`)
-   **Framework**: `tkinter` for GUI, `speech_recognition` for NLP.
-   **Features**:
    -   **Modes**: Normal & Critical Mode switching.
    -   **Commands**: "Increase/Decrease Blood Flow", "Alarm On/Off", "Reset".
    -   **Connectivity**: Multithreaded HTTP client to talk to ESP32.

### 2. ESP32 Firmware (`Sketch and GUI/Sketch`)
-   **Language**: Embedded C++.
-   **Libraries**: `ESP8266WiFi`, `ESP8266WebServer`, `ArduinoJson`.
-   **Logic**:
    -   Polls Firebase for vitals every second.
    -   Parses JSON data to monitor patient health.
    -   Listens for HTTP commands to toggle pins (LEDs).

### 3. Patient Simulator (Flutter App)
-   **Framework**: Flutter.
-   **Path**: Root directory.
-   **Features**: Visualizes patient status and vitals dashboard.

---

## 🚀 Setup Instructions

### Python GUI
1.  Navigate to `Sketch and GUI/GUI`.
2.  Install dependencies:
    ```bash
    pip install tk SpeechRecognition requests
    ```
3.  Run the controller:
    ```bash
    python Control_Center.py
    ```
    *Note: Ensure your PC is on the same network as the ESP32.*

### ESP32
1.  Open `Sketch and GUI/Sketch/Sketch.ino` in Arduino IDE.
2.  Update `ssid` and `password` with your WiFi credentials.
3.  Upload to your ESP8266/ESP32 board.
4.  Note the IP Address printed in the Serial Monitor and update it in `Control_Center.py`.

### Flutter App
1.  From the root directory, install dependencies:
    ```bash
    flutter pub get
    ```
2.  Run the app:
    ```bash
    flutter run
    ```

---

## 👥 Team

-   **MRIDUL VINOD KUMAR** – Medical Student at Govt. Medical College, Thiruvananthapuram
-   **SIDDHARTH** – Doing BTech at CUSAT
-   **The Python Guy** – 
-   **The Other Python Guy** – 

---

## 🏆 Event

**TinkerHub 24-Hour Hackathon**
📅 January 31 – February 1
