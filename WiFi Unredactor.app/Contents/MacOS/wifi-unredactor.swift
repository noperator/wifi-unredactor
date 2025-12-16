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
            if let interface = CWWiFiClient.shared().interface() {
                var jsonOutput: [String: String] = [:]

                jsonOutput["interface"] = interface.interfaceName

                if let ssid = interface.ssid() {
                    jsonOutput["ssid"] = ssid
                } else {
                    jsonOutput["ssid"] = "failed to retrieve SSID"
                }

                if let bssid = interface.bssid() {
                    jsonOutput["bssid"] = bssid
                } else {
                    jsonOutput["bssid"] = "failed to retrieve BSSID"
                }

                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonOutput, options: .prettyPrinted),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                } else {
                    print("error: failed to create JSON")
                }
            }
            NSApp.terminate(nil)
        } else {
            let jsonOutput = ["error": "location services denied"]
            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonOutput, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            } else {
                print("error: failed to create JSON")
            }
            NSApp.terminate(nil)
        }
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
