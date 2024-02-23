import SwiftUI
import CoreLocation
import MapKit
import SDWebImageSwiftUI
import UserNotifications

class LocationDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var speedLimit: Int?
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var isLoading = false
    let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            userLocation = location.coordinate
            getTrafficInfo(latitude: latitude, longitude: longitude)
            
            if let speedLimit = speedLimit, Double(location.speed) > Double(speedLimit) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                    if granted {
                        let content = UNMutableNotificationContent()
                        content.title = "Speed Limit Exceeded"
                        content.body = "You have exceeded the speed limit of \(speedLimit) km/h."
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                        let request = UNNotificationRequest(identifier: "SpeedLimitExceeded", content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request)
                    }
                }
            }
        }
    }

    func getTrafficInfo(latitude: Double, longitude: Double) {
        let tomtomApiKey = "K6XCzw97Ogk4D3domsrHaA6YC2hngIzB"
        let endpoint = "https://api.tomtom.com/traffic/services/4/flowSegmentData/absolute/10/json"
        let url = URL(string: "\(endpoint)?point=\(latitude),\(longitude)&key=\(tomtomApiKey)")!

        self.isLoading = true 

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    if let trafficData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let flowSegmentData = trafficData["flowSegmentData"] as? [String: Any] {
                            if let currentSpeed = flowSegmentData["currentSpeed"] as? Int {
                                DispatchQueue.main.async {
                                    self.speedLimit = currentSpeed
                                    self.isLoading = false 
                                }
                            }
                        }
                    }
                } catch {
                    print("Error parsing traffic data: \(error.localizedDescription)")
                    self.isLoading = false 
                }
            } else {
                print("Error fetching traffic info: \(error?.localizedDescription ?? "Unknown error")")
                self.isLoading = false 
            }
        }.resume()
    }

    func openInMaps(latitude: Double, longitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = "User's Location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

struct ContentView: View {
    @StateObject var locationDelegate = LocationDelegate()

    var body: some View {
        VStack {
            if let speed = locationDelegate.speedLimit {
                AnimatedImage(url: URL(string: "https://cdnl.iconscout.com/lottie/premium/thumb/alert-6248630-5110025.gif"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                Text("The speed limit is: \(speed) km/h")
                    .font(.title)
                    .foregroundColor(.blue)
                if let location = locationDelegate.userLocation {
                    Button("Open in Maps") {
                        locationDelegate.openInMaps(latitude: location.latitude, longitude: location.longitude)
                    }
                }
            } else {
                if locationDelegate.isLoading {
                    ProgressView("Loading...")
                } else {
                    Text("Fetching speed limit...")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}