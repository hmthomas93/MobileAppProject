//
//  PlaceAnnotation.swift
//  TravelApp
//
//  Created by Sumner Van Schoyck on 3/18/16.
//  Copyright © 2016 Team Taylor Swift. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    let title:String?
    let subtitle:String?
    let coordinate:CLLocationCoordinate2D
    
    init(t:String, s:String, c:CLLocationCoordinate2D) {
        self.title = t
        self.subtitle = s
        self.coordinate = c
        
        super.init()
    }
}