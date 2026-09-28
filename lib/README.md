# 🎯 Passaparola - English Vocabulary Game

An interactive vocabulary builder mobile game built with **Flutter**, inspired by the classic European word wheel format (*Pasapalabra / The Alphabet Game*). 

The game presents players with 26 letters arranged in a circular dial. Players can answer definitions either via speech recognition (microphone) or text input, skip questions to return in subsequent rounds, and track real-time score and time metrics.

---

## ✨ Features

- **Circular Letter Dial UI:** Custom mathematical placement ($\theta = \frac{2\pi \cdot i}{26}$) rendering a 26-letter interactive wheel.
- **Voice Recognition Integration:** Real-time speech-to-text processing using `speech_to_text` for hands-free voice gameplay.
- **CEFR-Aligned Levels:** 3 tailored difficulty tiers:
  - `A1 - A2` (Elementary / Beginner)
  - `B1 - B2` (Intermediate / Upper-Intermediate)
  - `C1 - C2` (Advanced / Mastery)
- **Bilingual Clue System:** Switch between English definitions and Turkish clues for flexible learning tracks.
- **Core Game Loop:** Pass mechanism, active state management, 180s countdown timer, and performance breakdown dialog.
- **Cross-Platform Ready:** Configured for Android and iOS with native microphone and speech permissions.

---

## 🛠️ Tech Stack & Architecture

| Layer | Technology |
|---|---|
| **Framework** | Flutter (Dart SDK) |
| **Speech Engine** | `speech_to_text` (Native Android/iOS bridge) |
| **State & Lifecycle** | Flutter State Management & Timer Architecture |
| **UI/UX** | Math/Trig Geometry rendering with Custom Canvas |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Dart SDK

### Installation

1. Clone the repository:
   ```bash
   git clone [https://github.com/eceshne-blip/passaparola-vocabulary-game.git](https://github.com/eceshne-blip/passaparola-vocabulary-game.git)
   cd passaparola-vocabulary-game
   flutter pub get
   flutter run

   deployed
   