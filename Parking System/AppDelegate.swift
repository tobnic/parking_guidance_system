//
//  AppDelegate.swift
//  Parking System
//
//  Created by Tobias on 30/11/2016.
//  Copyright © 2016 Tobias. All rights reserved.
//

import UIKit
import GoogleMaps
/**
    App Delegate
*/
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Properties

    /// Main Window for the App
    var window: UIWindow?
    /// Stores all the parking Lots. Array of `ParkingLot` Objects
    var parkingLots : [ParkingLot] = []
    /// Stores the data Stream from the downloaded XML
    var parkingLotData : Data?

    // MARK: Delegate methods
    /**
        Stores the Google API Key and the Parking Lot basic information
    */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyC75VB33B-GFFEAa3870Y936Fd54q3MTJI")
        
        
        //
        // Create all parkingspots with the missing data
        //
        parkingLots.append(ParkingLot(name: "Parkgarage Am Ziegeltor", location: CLLocationCoordinate2D.init(latitude: 49.44852, longitude: 11.856722), pricePerHour: "1,00", opening: "00:00:00", closing: "23:59:59", costOpening: "00:00:00", costClosing: "23:59:59",  xmlID : 4))
        
        parkingLots.append(ParkingLot(name: "Parkplatz Kräuterwiese", location: CLLocationCoordinate2D.init(latitude: 49.448578, longitude: 11.853039), pricePerHour: "0,50", opening: "00:00:00", closing: "23:59:59", costOpening: "08:00:00", costClosing: "18:00:00",  xmlID : 3))
        
        parkingLots.append(ParkingLot(name: "Parkgarage am Kurfürsenbad", location: CLLocationCoordinate2D.init(latitude: 49.441495, longitude: 11.860556), pricePerHour: "1,00", opening: "00:00:00", closing: "23:59:59", costOpening: "06:00:00", costClosing: "22:00:00",  xmlID : 1))
        
        parkingLots.append(ParkingLot(name: "Theatergarage", location: CLLocationCoordinate2D.init(latitude: 49.446406, longitude: 11.854835), pricePerHour: "1,00", opening: "00:00:00", closing: "23:59:59", costOpening: "07:00:00", costClosing: "23:00:00",  xmlID : 2))
        
        parkingLots.append(ParkingLot(name: "Kurführstenbad", location: CLLocationCoordinate2D.init(latitude: 49.442074, longitude: 11.858784), pricePerHour:"1,00", opening: "00:00:00", closing: "23:59:59", costOpening: "06:00:00", costClosing: "22:00:00",  xmlID : 5))
        
        parkingLots.append(ParkingLot(name: "Kino", location: CLLocationCoordinate2D.init(latitude: 49.444278, longitude: 11.864445), pricePerHour: "-", opening: "00:00:00", closing: "23:59:59", costOpening: "06:00:00", costClosing: "22:00:00",  xmlID : 6))
        
        parkingLots.append(ParkingLot(name: "ACC", location: CLLocationCoordinate2D.init(latitude: 49.441027, longitude: 11.860675), pricePerHour: "0,50", opening: "00:00:00", closing: "23:59:59", costOpening: "08:00:00", costClosing: "18:00:00",  xmlID : 7))
        
        parkingLots.append(ParkingLot(name: "Altstadtgarage", location: CLLocationCoordinate2D.init(latitude: 49.447475, longitude: 11.861442), pricePerHour: "1,00", opening: "00:00:00", closing: "23:59:59", costOpening: "00:00:00", costClosing: "23:59:59",  xmlID : 8))
        
        return true
    }
    /// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    /// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    func applicationWillResignActive(_ application: UIApplication) {

    }
    /// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    /// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    func applicationDidEnterBackground(_ application: UIApplication) {

    }
    
    /// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    func applicationWillEnterForeground(_ application: UIApplication) {

    }
    /// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    func applicationDidBecomeActive(_ application: UIApplication) {

    }
    /// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    func applicationWillTerminate(_ application: UIApplication) {

    }


}

