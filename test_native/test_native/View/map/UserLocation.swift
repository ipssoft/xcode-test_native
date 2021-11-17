//
//  UserLocation.swift
//  test_native
//
//  Created by ihor on 04.11.2021.
//

import CoreLocation

class UserLocation: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastLocation: CLLocationCoordinate2D?
    var completion: ((CLLocation) -> Void)?
    
    override init(){
        super.init()
        manager.delegate = self
    }
    
    func start(completion: @escaping ((CLLocation) -> Void)){
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else {return}
        lastLocation = loc.coordinate
        completion?(loc)
        manager.stopUpdatingLocation()
    }
}
