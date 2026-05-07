import Cocoa
import CoreLocation
import CoreWLAN
import Foundation

class AppDelegate: NSObject, NSApplicationDelegate, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorized {
            guard let interface = CWWiFiClient.shared().interface() else {
                print(toJSON(["error": "no wifi interface found"]))
                NSApp.terminate(nil)
                return
            }

            do {
                let networks = try interface.scanForNetworks(withName: nil)

                let accessPoints: [[String: Any]] = networks
                    .sorted { $0.rssiValue > $1.rssiValue } // strongest signal first
                    .map { network in
                        [
                            "ssid":    network.ssid   ?? "<hidden>",
                            "bssid":   network.bssid  ?? "unknown",
                            "rssi":    network.rssiValue,
                            "channel": network.wlanChannel?.channelNumber ?? -1,
                        ]
                    }

                let output: [String: Any] = [
                    "interface":    interface.interfaceName ?? "unknown",
                    "access_points": accessPoints
                ]

                if let jsonData = try? JSONSerialization.data(withJSONObject: output, options: .prettyPrinted),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                } else {
                    print(toJSON(["error": "failed to serialize JSON"]))
                }

            } catch {
                print(toJSON(["error": "scan failed: \(error.localizedDescription)"]))
            }

            NSApp.terminate(nil)

        } else {
            print(toJSON(["error": "location services denied"]))
            NSApp.terminate(nil)
        }
    }

    func toJSON(_ dict: [String: String]) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
              let str = String(data: data, encoding: .utf8) else {
            return #"{"error": "json serialization failed"}"#
        }
        return str
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()