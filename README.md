# AgriVision AI — On-Device Plant Disease Detector

An edge-AI mobile application built with **Flutter** and **TensorFlow Lite** to assist farmers and agronomists with real-time, offline detection of crop leaf blights directly from mobile devices.

---

## 1. Project Overview
AgriVision AI is an on-device computer vision mobile application designed to identify early-stage plant leaf pathologies. By packaging a compact TensorFlow Lite image classification model directly within a Flutter client, the application delivers instant diagnostic predictions with confidence scoring without requiring an active internet connection or cloud infrastructure.

## 2. Problem Statement
Fungal and bacterial blights (such as Early Blight and Late Blight) are leading causes of yield reduction in solanaceous crops like potatoes and tomatoes. Smallholder farmers often operate in remote environments with intermittent or non-existent internet connectivity, where access to agricultural extension officers and plant pathologists is delayed. An automated, offline diagnostic tool running on standard mobile hardware helps bridge this gap.

## 3. Objectives
- **On-Device Edge Inference:** Execute computer vision inference locally on mobile hardware to ensure zero latency and full offline availability.
- **Accessible Field Diagnostics:** Provide an intuitive mobile interface enabling photo capture via camera or import from device gallery.
- **Accurate Classification:** Categorize leaf health into distinct pathological states with real-time confidence metrics.
- **Resource Efficiency:** Maintain a compact binary footprint with optimized model loading and native memory management.

## 4. Implemented Features
- **Instant Photo Acquisition:** Seamless capture via native mobile camera or gallery selection using `image_picker`.
- **Offline ML Inference Engine:** On-device neural network execution powered by `tflite_v2`.
- **Confidence Scoring:** Real-time visual display showing top diagnostic predictions with percentage confidence metrics.
- **Leaf Preview Card:** High-resolution image preview card displaying the selected or photographed specimen.
- **Graceful Lifecycle Management:** Explicit initialization and cleanup (`Tflite.close()`) of native inference tensors to prevent memory leaks.

## 5. Technology Stack
- **Framework:** [Flutter](https://flutter.dev/) (Dart SDK `^3.9.2`)
- **Machine Learning Engine:** [TensorFlow Lite](https://www.tensorflow.org/lite) (`tflite_v2`)
- **Hardware Integration:** `image_picker` (Camera & Photo Library access)
- **Native Platform:** Android (Gradle KTS, Kotlin, Java 17, `compileSdk 36`)
- **Asset Packaging:** Android AAPT uncompressed asset mapping for `.tflite` binaries

## 6. AI/ML Methodology
- **Model Architecture:** Lightweight Convolutional Neural Network (MobileNet / transfer-learning backbone) converted to TensorFlow Lite format (`assets/model.tflite`, ~2.09 MB).
- **Input Normalization:** Preprocessed with standard RGB scaling parameters:
  - Mean: `127.5`
  - Standard Deviation: `127.5`
  - Target value domain: `[-1.0, 1.0]`
- **Inference Parameters:**
  - Confidence Threshold: `0.50` (50% cutoff)
  - Output Classes: Top 2 predictions (`numResults: 2`)
- **Target Disease Categories (`assets/labels.txt`):**
  1. `healthy` — Leaf exhibiting no visible signs of pathogen infection.
  2. `early_blight` — Concentric ring spot lesions (*Alternaria solani*).
  3. `late_blight` — Water-soaked, dark lesions with irregular margins (*Phytophthora infestans*).

## 7. Dataset Information
The model targets class categories standard in open agricultural benchmarks (such as the PlantVillage benchmark dataset for Solanaceae crop leaf pathologies).

> *Note: For reproduction or benchmark metrics, refer to the original training logs or dataset documentation.*

## 8. System Architecture
```
┌────────────────────────────────────────────────────────┐
│                   AgriVision Mobile UI                 │
│              (Flutter / Material Widgets)              │
└───────────┬────────────────────────────────┬───────────┘
            │ User Action                    │ Image File
            ▼                                ▼
┌───────────────────────┐        ┌───────────────────────┐
│     Image Picker      │        │  Preprocessing Engine │
│   (Camera / Gallery)  │───────▶│ (Mean/Std: 127.5/127.5)│
└───────────────────────┘        └───────────┬───────────┘
                                             │ Normalized Tensor
                                             ▼
                                 ┌───────────────────────┐
                                 │ TFLite Native Runtime │
                                 │   (assets/model.tflite│
                                 │   + assets/labels.txt)│
                                 └───────────┬───────────┘
                                             │ Top Predictions
                                             ▼
                                 ┌───────────────────────┐
                                 │ Prediction Card & UI  │
                                 │ (Label + Confidence %)│
                                 └───────────────────────┘
```

## 9. Folder Structure
```
agrivision-ai/
├── android/                   # Native Android host configuration
│   ├── app/
│   │   ├── build.gradle.kts   # Android build setup (AAPT uncompressed tflite)
│   │   └── src/main/          # AndroidManifest (Camera & Storage permissions)
├── assets/                    # Deployed ML binaries & labels
│   ├── app_logo.png           # Application icon asset
│   ├── labels.txt             # Class index to disease name mapping
│   └── model.tflite           # Quantized/Float TFLite model weights (2.09 MB)
├── ios/                       # Native iOS runner scaffold
├── lib/
│   └── main.dart              # Core application entrypoint, UI, and ML pipeline
├── test/
│   └── widget_test.dart       # Test scaffold
├── pubspec.yaml               # Flutter package configuration & asset bindings
└── README.md                  # Project documentation
```

## 10. Installation Requirements
- **Flutter SDK:** Version `3.19.0` or higher (Dart `^3.9.2`)
- **Java Development Kit (JDK):** Version 17
- **Android SDK:** Platform tools and build-tools (target SDK 36)
- **Target Device:** Android device (API 21+) or Android Emulator with Camera/Virtual Scene enabled

## 11. Installation and Execution Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/<YOUR_GITHUB_USERNAME>/AgriVision-AI.git
   cd AgriVision-AI
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter environment:**
   ```bash
   flutter doctor
   ```

4. **Connect a target device:**
   Ensure an Android device with USB debugging enabled is plugged in, or launch an Android emulator:
   ```bash
   flutter devices
   ```

5. **Run the application:**
   ```bash
   flutter run
   ```

6. **Build release APK (Optional):**
   ```bash
   flutter build apk --release
   ```

## 12. How to Use the Application
1. **Launch**: Open AgriVision AI on your device. The model initializes into memory automatically.
2. **Select Input Method**:
   - Tap **Camera** to capture a clear photo of an affected plant leaf.
   - Tap **Gallery** to select an existing leaf photo from your device storage.
3. **Inspect Output**:
   - The selected leaf appears in the preview window.
   - Diagnosed condition (`healthy`, `early_blight`, or `late_blight`) will display beneath the preview along with its computed confidence percentage.

## 13. Screenshots Section
*(Add screenshots of your running application on device or emulator here before sharing with recruiters)*

| Model Loading & Standby | Leaf Disease Detection |
| :---: | :---: |
| ![Standby Screenshot](docs/screenshots/standby.png) | ![Detection Screenshot](docs/screenshots/detection.png) |

## 14. Testing Information
- Static code analysis is configured via `analysis_options.yaml` (`package:flutter_lints/flutter.yaml`).
- Run static analysis locally:
  ```bash
  flutter analyze
  ```
- *Note on Automated Tests:* Unit and UI automated widget tests are currently under development; verification has been performed via on-device integration testing across Android environments.

## 15. Known Limitations
- **Class Scope:** Classification is currently constrained to the three trained classes (`healthy`, `early_blight`, `late_blight`). Non-leaf objects or other crop pathologies will be assigned the closest matching class.
- **Lighting and Background Sensitivity:** Predictions are most reliable when images are taken with uniform lighting against neutral backgrounds without severe glare.
- **iOS Execution:** Android is the verified execution target. iOS deployment requires adding `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription` keys into `ios/Runner/Info.plist`.

## 16. Future Improvements
- Expand model taxonomy to detect 20+ crop diseases (maize, rice, wheat, and apple).
- Add offline treatment and organic pesticide recommendation guides corresponding to diagnosed diseases.
- Integrate an offline SQLite/Hive database to record scan histories with GPS geotagging for disease spread mapping.
- Upgrade to `tflite_flutter` or Google Mediapipe for cross-platform desktop/web acceleration.

## 17. Author
- **Developer:** [Kamalesh](https://github.com/<YOUR_GITHUB_USERNAME>)
- **Portfolio / LinkedIn:** [LinkedIn Profile](https://linkedin.com/in/<YOUR_PROFILE>)
- **Email:** [Contact Email](mailto:your.email@example.com)
