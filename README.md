# WiFi Unredactor

WiFi Unredactor is a minimal macOS application designed to retrieve Wi-Fi network information—specifically, the SSID (network name) and BSSID (access point MAC address)—while adhering to macOS's strict privacy requirements. Starting with macOS Sonoma, Apple introduced changes that restrict access to Wi-Fi information from command-line tools (`airport`, `ioreg`, `networksetup`, `system_profiler`, `wdutil`) without proper location services permissions.

```
𝄢 /System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport
WARNING: The airport command line tool is deprecated and will be removed in a future release.
For diagnosing Wi-Fi related issues, use the Wireless Diagnostics app or wdutil command line tool.

𝄢 sudo wdutil info
MAC Address : <redacted> (hw=<redacted>)
SSID        : <redacted>
BSSID       : <redacted>
```

This project provides a solution by using a lightweight GUI wrapper solely to trigger the location services permission prompt. Once permission is granted, the application is intended to be run via the command line.

### Install

```bash
𝄢 git clone https://github.com/noperator/wifi-unredactor
𝄢 cd wifi-unredactor
𝄢 ./build-and-install.sh
Compiling WiFi Unredactor...
Compilation successful.
Signing binary...
WiFi Unredactor.app/Contents/MacOS/wifi-unredactor: replacing existing signature
Installing WiFi Unredactor to /Users/clg/Applications...
Installation complete. WiFi Unredactor is now available in /Users/clg/Applications
```

### Configure

You'll need to **grant location services permission** to this application for it to work properly.

1. Navigate to System Settings > Privacy & Security > Location Services. Make sure that Location Services is toggled to the "on" position. Keep this window open so you can watch and wait for Wifi Unredactor to appear.
2. Run `open ~/Applications/WiFi\ Unredactor.app` to trigger the initial prompt for location services permission. Click allow. Sometimes Wifi Unredactor will silently appear in the list of applications under Location Services (with the toggle in the "off" position), so do watch that list in case it shows up.
3. Navigate back to System Settings > Privacy & Security > Location Services. If you don't see WiFi Unredactor in the list of apps, try refreshing the list by clicking the back button and then clicking back into Location Services. Toggle WiFi Unredactor to the "on" position.

### Usage

Now, you can get your precious (B)SSIDs from CLI 🎉

```bash
𝄢 ~/Applications/WiFi\ Unredactor.app/Contents/MacOS/wifi-unredactor
{
  "interface" : "en0",
  "ssid" : "BrightSquirrelNet72",
  "bssid" : "4A:3B:1C:D2:E5:F8"
}
```

### Troubleshooting

If you get the error `location services denied`, make sure you've enabled location services as described in the [Configure](#configure) section.

### See also

- https://forums.developer.apple.com/forums/thread/732431
- https://github.com/ehemmete/NetworkView
