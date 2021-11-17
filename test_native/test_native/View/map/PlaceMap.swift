//
//  PlaceMap.swift
//  test_native
//
//  Created by ihor on 06.11.2021.
//

import SwiftUI
import MapKit

struct PlaceMap: Identifiable{
    let id: UUID
    var location: CLLocationCoordinate2D
    init(id: UUID = UUID(), lat: Double, long: Double){
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat, longitude: long
        )
    }
}
