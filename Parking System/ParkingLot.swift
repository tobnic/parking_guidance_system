//
//  ParkingLot.swift
//  Parking System
//
//  Created by Tobias on 02/12/2016.
//  Copyright © 2016 Tobias. All rights reserved.
//

import Foundation
import MapKit
/**
    Provides a object for the parking lot
*/
class ParkingLot {
    // MARK: Properties
    /// The name of the parking lot
    var name : String
    
    /// The capazity of the parking lot
    var capazity : Int
    
    /// The location of the parking lot
    var location : CLLocationCoordinate2D
    
    /// The price per hour of the parking lot
    var pricePerHour : String
    
    /// The opening time of the parking lot
    var opening : Date
    
    /// The closing time of the parking lot
    var closing : Date
    
    /// The opening time for the parking fee
    var costOpening : Date
    
    /// The closing time for the parking fee
    var costClosing : Date
    
    /// The XML ID of the parking lot
    var xmlID : Int
    
    /// The parking trend of the parking lot
    var trend : Int
    
    /// The status of the parking lot
    var status : String
    
    /// 1: if the parking lot is closed 0: if is open
    var closed : Int
    
    /// If the current parking lot is responsible for the zoom in the map
    var gotZoomed : Bool
    
    /// If the parking lot is in the favorite list of the user
    var isFavVisible : Bool
    
    /// If the parking lot is 24 hours fee-based
    var is24hFeeBased : Bool
    
    /**
        Standard parking lot initialisation. All Properties gets filled with default values.
    */
    init(){
        self.name = ""
        self.capazity = 0
        self.location = CLLocationCoordinate2D()
        self.pricePerHour = ""
        self.opening = Date()
        self.closing = Date()
        self.costOpening = Date()
        self.costClosing = Date()
        self.xmlID = 0
        self.trend = 0
        self.status = "OK"
        self.closed = 0
        self.gotZoomed = false
        self.isFavVisible = true
        self.is24hFeeBased = false
    }
    /**
        Initialize the parking lot with parameters.
     
        - parameter name: The name of the parking lot
        - parameter location: The location for the parking lot
        - parameter pricePerHour: The price per hour for the parking lot
        - parameter opening: The opening time for the parking lot
        - parameter closing: The closing time for the parking lot
        - parameter costOpening: The opening time for the parking fee
        - parameter costClosing: The closing time for the parking fee
        - parameter xmlID:The XML ID of the parking lot
     
    */
    init( name : String, location : CLLocationCoordinate2D, pricePerHour : String, opening : String, closing : String, costOpening : String, costClosing : String, xmlID : Int){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"

        self.name = name
        self.capazity = 0
        self.location = location
        self.pricePerHour = pricePerHour
        self.opening = dateFormatter.date(from: opening)!
        self.closing = dateFormatter.date(from: closing)!
        self.costOpening = dateFormatter.date(from: costOpening)!
        self.costClosing = dateFormatter.date(from: costClosing)!
        self.xmlID = xmlID
        self.trend = 0
        self.status = "OK"
        self.closed = 0
        self.gotZoomed = false
        self.isFavVisible = true
        if dateFormatter.date(from: costOpening) == dateFormatter.date(from: "00:00:00") && dateFormatter.date(from: costClosing) == dateFormatter.date(from: "23:59:59"){
            self.is24hFeeBased = true
        }
        else{
            self.is24hFeeBased = false
        }
    }
    
}
