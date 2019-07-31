//
//  Constant.swift
//  Parking System
//
//  Created by Tobias on 08/12/2016.
//  Copyright © 2016 Tobias. All rights reserved.
//

import Foundation
/**
    Provides standard parameter
*/
struct InitMap {
    /// the zoom factor for the map view
    static let zoom = 14.8 as Float!
    
    /// start latitude of the map
    static let latitude = 49.445273 as Double!
    
    /// start longitude of the map
    static let longitude = 11.857122 as Double!
    
    /// zoom distance from the user to a parking lot
    static let zoomDistance = 150 as Int!
    
    /// the update refresh time for the map view
    static let udpateTimer = 60 as Double!
    
}

