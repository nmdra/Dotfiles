# 🎬 mpv Configuration Guide

A modernized, high-performance mpv setup featuring **ModernZ**, high-quality rendering, and a curated set of functional scripts.

## 🚀 Highlights

- **Core Engine:** Uses `vo=gpu-next` and `gpu-hq` for superior visual fidelity.
- **OSC Replacement:** [ModernZ](https://github.com/Samillion/ModernZ) provides a sleek, modern UI with hover thumbnails.
- **Hardware Decoding:** Optimized with `hwdec=auto-safe` and silent fallback handling.
- **Audio:** Intelligent dynamic normalization (`dynaudnorm`) enabled by default.

---

## ⌨️ Essential Keybindings

### **Playback & Navigation**
| Key | Action |
| :--- | :--- |
| `SPACE` | Toggle Pause |
| `f` | Toggle Fullscreen |
| `m` | Mute/Unmute |
| `UP` / `DOWN` | Adjust Volume |
| `[` / `]` | Adjust Speed (±0.25) |
| `{` / `}` | Reset Speed to 1.0 |
| `q` | Quit and Save Position |

### **Seeking**
| Key | Interval |
| :--- | :--- |
| `LEFT` / `RIGHT` | 5 Seconds |
| `Ctrl + LEFT/RIGHT` | 10 Seconds |
| `Shift + UP/DOWN` | 30 Seconds |
| `Ctrl + UP/DOWN` | Subtitle Seek (Prev/Next Sub) |

### **UI & Scripts**
| Key | Script / Feature |
| :--- | :--- |
| `v` | **ModernZ:** Cycle UI Visibility |
| `w` | **ModernZ:** Toggle Persistent Progress Bar |
| `x` | **ModernZ:** Temporarily Show OSC |
| `SHIFT + ENTER`| **Playlist Manager:** Open Visual Playlist |
| `Ctrl + f` | **Quality Menu:** Change Stream Quality (YouTube, etc.) |
| `F11` | **Skip Silence:** Toggle Auto-Skip Silent Parts |
| `t` | **Seek To:** Input Absolute Timestamp |
| `F5` / `Ctrl + r` | **Reload:** Reload stuck streams |
| `PGUP` / `PGDWN` | **Better Chapters:** Next/Prev Chapter (cross-file) |

### **Video & Audio Filters**
| Key | Action |
| :--- | :--- |
| `b` | Toggle Debanding |
| `B` | Cycle Deband Strength (Light/Med/Heavy) |
| `F2` | Cycle Audio Normalization (Loudnorm/Dynaudnorm/Off) |

---

## 🛠 Active Scripts

1.  **ModernZ:** The primary On-Screen Controller.
2.  **Thumbfast:** Provides hover thumbnails on the seekbar.
3.  **Playlist Manager:** Manage your queue with a visual menu.
4.  **Skip Silence:** Automatically fast-forwards through silence (ideal for lectures/talks).
5.  **Quality Menu:** On-the-fly quality switching for web streams.
6.  **Better Chapters:** Seamless chapter navigation that can jump between files.
7.  **Reload:** Automatically fixes streams that stop buffering.
8.  **Night Color:** Automatically toggles system blue-light filters during playback (Linux/KDE).
9.  **Audio Visualizer:** Visualizes audio for music files.

---

## 📁 Directory Structure
- `mpv.conf`: Main performance and player settings.
- `input.conf`: All custom keybindings listed above.
- `scripts/`: Lua scripts for extended functionality.
- `script-opts/`: Individual configuration files for scripts.
- `fonts/`: Icon fonts required for ModernZ.
