# TomTom Maps API Integration

This project integrates the TomTom Maps API to provide advanced mapping features.

## TomTom API Key

Usage
To use the TomTom Maps API in your code, you can make requests to the TomTom API endpoints using the HTTP client of your choice. Here's an example of how to make a request to retrieve the current speed limit at a specific location using the TomTom API:

## Screenshots

<div style="display: flex; justify-content: space-around; align-items: center;">
  <img src="https://k.top4top.io/p_29752os6l1.png" alt="Screenshot 1" style="width:250px;height:500px; border-radius: 40px; box-shadow: 5px 5px 5px #888888;">
  <img src="https://j.top4top.io/p_2975up1mc0.jpeg" alt="Screenshot 2" style="width:250px;height:500px; border-radius: 40px; box-shadow: 5px 5px 5px #888888;">
</div>

```swift 
func getCurrentSpeedLimit(at location: CLLocationCoordinate2D) {
    // Construct the URL for the TomTom Speed Limit API
    let apiKey = "YOUR_API_KEY_HERE"
    let urlString = "https://api.tomtom.com/speed/1/tile/basic/main/" + 
                    "\(location.latitude),\(location.longitude).json?key=\(apiKey)"
    
    // Make a request to the TomTom Speed Limit API
    // (Add code here to make the HTTP request and handle the response)
}
```

To use the TomTom Maps API, you will need to sign up on the TomTom Developer Portal to obtain an API key. Once you have the API key, you can configure it in the app by adding it to the `Info.plist` file as follows:

```xml
<key>TomTomAPIKey</key>
<string>YOUR_API_KEY_HERE</string>
```

## Resources

- [TomTom Developer Portal](https://developer.tomtom.com/)
- [TomTom Maps API Documentation](https://developer.tomtom.com/maps-api)
