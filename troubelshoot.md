
# termux exiting with signal 9

## For Android 14+:
- Go to your phone's Settings.
- Navigate to System > Developer options. (If you don't see Developer options, go to "About phone" and tap "Build number" multiple times until it appears).
- In the Apps section, enable the option called "Disable child process restrictions".


## Android 12L & Android 13+:

### Setup adb in termux itself
1. Install tools: Run `pkg install android-tools` in Termux.
2. Enable Debugging: Turn on Developer Options > Wireless Debugging.
3. Pairing: Select "Pair device with pairing code." Note the IP, Port, and Code.
4. Connect in Termux: Use the command: adb pair localhost:port (use the Pairing port and Code provided).
5. Connect to ADB: Run adb connect localhost:port

```bash
adb shell "settings put global settings_enable_monitor_phantom_procs false"
```

## Android 12:
```bash
adb shell "/system/bin/device_config set_sync_disabled_for_tests persistent"
adb shell "/system/bin/device_config put activity_manager max_phantom_processes 2147483647"
```