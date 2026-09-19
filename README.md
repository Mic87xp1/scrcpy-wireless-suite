# Wireless scrcpy Automation Suite

A lightweight pair of Windows Batch scripts designed to automate environment setup, dependency management, and ADB Wi-Fi connection for low-latency Android screen mirroring and streaming using [`scrcpy`](https://github.com/Genymobile/scrcpy).

Optimized specifically for wireless gaming and live streaming with low bitrates and minimal audio latency.

---

## 🌟 Key Features

* **Smart Environment Setup (`setup_environment.bat`)**:
  * Scans system `PATH` to detect existing installations of `adb` and `scrcpy`.
  * Downloads official binaries (*Android Platform Tools* and *scrcpy v3.1*) only if missing.
  * Automatically configures Windows User Environment Variables (`PATH`) via PowerShell.
  * Fully idempotent—safe to run multiple times without duplicating binaries or environment variables.

* **Automated Launcher (`start_scrcpy.bat`)**:
  * **Dependency Guard**: Checks for required executables before running, displaying clear error messages if dependencies are missing.
  * **Interactive IP Prompt**: Prompts for the Android device's local IP address at launch.
  * **Session Cleanup**: Flushes stale or offline ADB connections (`adb disconnect`) before connecting.
  * **Tuned Streaming Preset**: Launches `scrcpy` with settings optimized for 60 FPS wireless gameplay and live streaming.

---

## 📋 Prerequisites

1. **Windows OS** (Windows 10 / 11) with PowerShell enabled.
2. **Android Device** connected to the same Wi-Fi network as your PC (5 GHz Wi-Fi recommended).
3. **Developer Options & USB Debugging** enabled on your Android phone.
4. **Initial ADB Pairing**: Your Android device must be paired with ADB over TCP/IP port `5555`.
   > *Note: If connecting for the first time, plug the phone via USB once and run `adb tcpip 5555`.*

---

## 🚀 Quick Start

### Step 1: Clone or Download
Clone this repository or download the source `.bat` files into a folder on your computer.

```bash
git clone [https://github.com/your-username/scrcpy-wireless-suite.git](https://github.com/your-username/scrcpy-wireless-suite.git)
cd scrcpy-wireless-suite
```

### Step 2: Run Environment Setup
Double-click `setup_environment.bat` (or run it from CMD).

* If `adb` or `scrcpy` are missing, the script will download them to `%USERPROFILE%\scrcpy_tools` and add them to your user `PATH`.
* **Important**: If the script updates your `PATH`, close and reopen your Command Prompt / Terminal window for changes to take effect.

### Step 3: Launch Wireless Mirroring
Double-click `start_scrcpy.bat`:

1. Enter your phone's Wi-Fi IP address when prompted (e.g., `192.168.1.157`).
2. The script will handle ADB disconnection, connect to the target IP, and start `scrcpy`.

---

## ⚙️ Default Streaming Configuration

The launcher script triggers `scrcpy` with the following parameters optimized for wireless performance:

```cmd
scrcpy -s %PHONE_IP%:5555 -b 4M --max-fps=60 -m 1080 --audio-buffer=40 -w
```

| Flag | Purpose |
| :--- | :--- |
| `-s %PHONE_IP%:5555` | Directs `scrcpy` to target the specific wireless IP instance. |
| `-b 4M` | Caps video bitrate at 4 Mbps to prevent Wi-Fi buffer bloat and stuttering. |
| `--max-fps=60` | Caps stream frame rate to a smooth 60 FPS. |
| `-m 1080` | Limits maximum resolution height to 1080p. |
| `--audio-buffer=40` | Reduces audio latency buffer down to 40ms for real-time sound sync. |
| `-w` (`--stay-awake`) | Prevents the phone screen from sleeping while connected. |

---

## 📁 Repository Structure

```text
.
├── setup_environment.bat   # Smart installer & PATH configurator
├── start_scrcpy.bat        # Interactive launcher & ADB connection script
└── README.md               # Documentation
```

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).