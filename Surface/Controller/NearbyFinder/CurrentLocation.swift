//
//  CurrentLocation.swift
//  
//
//  Created by Appinventiv Mac on 11/04/18.
//

import UIKit
import CoreLocation

// MARK: PROTOCOL TO GET LAT AND LNG OF DEVICE
// ===========================================

protocol GetMyLocation {
    func coordinates(_ lat:Float, _ lng:Float)
}

class CurrentLocation: UIViewController,CLLocationManagerDelegate {
    
    // MARK: CLASS PROPERTIES
    //=======================
    
    let LocatioManager = CLLocationManager()
    var location:CLLocation!
    var delegate:GetMyLocation?
    var lat,long:Float!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocatioManager.delegate=self
        LocatioManager.desiredAccuracy=kCLLocationAccuracyBest
        LocatioManager.requestAlwaysAuthorization()
        LocatioManager.startUpdatingLocation()
        
    }
}


    // MARK: DELEGATES METHODS
    // =======================

extension CurrentLocation{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations[locations.count-1]
        if   location.horizontalAccuracy > 0{
            self.lat = Float(location.coordinate.latitude)
            self.long = Float(location.coordinate.longitude)
            self.delegate?.coordinates(self.lat, self.long)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        LocatioManager.startUpdatingLocation()
        print()
    }
}
