//
//  LocationManager.swift
//  PawPaw
//
//  Created by Eric Ziegler on 11/1/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: Constants

let LocationUpdateSuccessNotification = Notification.Name("LocationUpdateSuccessNotification")
let LocationUpdateFailNotification = Notification.Name("LocationUpdateFailedNotification")
let HasInitializedLocationManagerCacheKey = "HasInitializedLocationManagerCacheKey"
let ValidZipCodeRegEx = "^[0-9]{5}(?:-[0-9]{4})?$"
let ZipCacheKey = "ZipCacheKey"

class ZipManager {
 
    // MARK: Properties
    
    var zip: String? {
        didSet {
            self.save()
            NotificationCenter.default.post(Notification(name: LocationUpdateSuccessNotification))
        }
    }
    
    // MARK: Init
    
    static let shared = ZipManager()
    
    init() {
        self.load()
    }
    
    // MARK: Loading
    
    private func load() {
        if let cachedZip = UserDefaults.standard.object(forKey: ZipCacheKey) as? String {
            self.zip = cachedZip
        }
    }
    
    // MARK: Saving
    
    private func save() {
        UserDefaults.standard.set(self.zip, forKey: ZipCacheKey)
        UserDefaults.standard.synchronize()
    }
    
}

class LocationManager: NSObject {

    // MARK: Properties
    
    private var locationManager: CLLocationManager!
    var isUsingCurrentLocation = false
    
    // MARK: Init
    
    static let shared = LocationManager()
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        UserDefaults.standard.set(true, forKey: HasInitializedLocationManagerCacheKey)
        UserDefaults.standard.synchronize()
    }
    
    func updateLocation() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.startUpdatingLocation()
    }
    
    // MARK: Convenience Methods
    
    class func isValidZip(_ zip: String) -> Bool {
        let zipRegEx = "^[0-9]{5}(-[0-9]{4})?$"
        let pinPredicate = NSPredicate(format: "SELF MATCHES %@", zipRegEx)
        let result = pinPredicate.evaluate(with: zip) as Bool
        return result
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if locations.count > 0 {
            let location = locations[0]
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if let placemarks = placemarks, placemarks.count > 0, error == nil {
                    let placemark = placemarks[0]
                    ZipManager.shared.zip = placemark.postalCode
                    self.isUsingCurrentLocation = true
                } else {
                    NotificationCenter.default.post(Notification(name: LocationUpdateFailNotification))
                }
            })
        } else {
            // this should never happen
            NotificationCenter.default.post(Notification(name: LocationUpdateFailNotification))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != CLAuthorizationStatus.authorizedWhenInUse {
            self.isUsingCurrentLocation = false
        }
        NotificationCenter.default.post(Notification(name: LocationUpdateFailNotification))
    }
    
}
