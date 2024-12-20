# ❄️ Snow Overlay

A magical snow effect overlay for macOS that creates falling snowflakes, snowboarders, and snowmen across your screen. Built with SwiftUI and AppKit.

## ✨ Features

- Fullscreen overlay that stays on top of other windows
- Multiple winter-themed emojis (❄️, 🏂, ⛄️)
- Dynamic animations with:
  - 3D rotations
  - Scale transitions
  - Opacity fading
  - Sparkle effects
- Different movement patterns for each emoji type
- Non-intrusive design (click-through functionality)
- Auto-terminates after animation completion

## 🚀 Installation

### Prerequisites
- macOS 14.6 or later
- Xcode 15.0 or later

### Building from Source
1. Clone the repository:
```bash
git clone https://github.com/yourusername/SnowOverlay.git
```
2.	Build using Xcode or terminal:
```bash
cd SnowOverlay
xcodebuild -scheme SnowOverlay -configuration Release -derivedDataPath build
```

3.	Run the app:
```bash
open build/Build/Products/Release/SnowOverlay.app
```

### 🎮 Usage
The app runs as a standalone overlay that:
	•	Appears immediately upon launch
	•	Displays animated winter emojis falling across your screen
	•	Automatically terminates once all animations complete
	•	Can be terminated early by Force Quit (⌘ + ⌥ + Esc)

### 🛠 Technical Details
Built using:
	•	SwiftUI for the animation views
	•	AppKit for window management
	•	Combines both frameworks for a native macOS experience
Key components:
	•	SnowView.swift: Handles the snow animation and emoji rendering
	•	SnowOverlayApp.swift: Manages the application window and lifecycle
	•	Uses NSPanel for a floating, click-through window experience

### 🤝 Contributing
Contributions are welcome! Feel free to:
	•	Report bugs
	•	Suggest enhancements
	•	Submit pull requests

### 📝 License

This project is released under the MIT License, which means it's completely free to use, modify, and distribute. You can:

- ✅ Use it commercially
- ✅ Modify it
- ✅ Distribute it
- ✅ Use it privately
- ✅ Use it for patents

The only requirement is to include the original license and copyright notice in any copy of the software/source.

See the [LICENSE](LICENSE) file for full details.

### 🙏 Acknowledgments
	•	Inspired by Raycast's confetti animation
	•	Built for the macOS developer community

### 📸 Screen recording
![Snow Overlay](SnowOverlay.gif)

