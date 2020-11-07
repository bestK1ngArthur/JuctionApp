//
//  Locator.swift
//  JunctionApp
//
//  Created by Artem Belkov on 08.11.2020.
//

import Foundation
import CoreLocation

class Locator: NSObject {
    static let current = Locator()
    
    var location: CLLocation? {
        locationManager.location
    }
    
    private(set) var city: String?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if let location = location {
            getCity(for: location) { city in
                self.city = city
            }
        }
    }
    
    private let locationManager = CLLocationManager()
}

extension Locator: CLLocationManagerDelegate {

    func getCity(for location: CLLocation, completion: @escaping (String?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
                        
            completion(placemark.locality)
        }
    }
}
