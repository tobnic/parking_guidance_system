//
//  ViewController.swift
//  Parking System
//
//  Created by Tobias on 30/11/2016.
//  Copyright © 2016 Tobias. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import SWXMLHash
import AVFoundation
import SystemConfiguration
	
/**
    The purpose of the ParkleitsystemViewController view controller is to provide a user interface
    where a user can the see free parking lots in the area of Amberg. Based on his location and settings
    the map will zoom in and provide information visually and acoustically.
 
    ## Important Notes ##
    1. A internet connection is necessary to provide the user with real live data
    2. Start point of the overview map is always Amberg
 
*/
class ParkleitsystemViewController: UIViewController,GMSMapViewDelegate, CLLocationManagerDelegate,XMLParserDelegate {
    
    // MARK: Properties
    /// Provides the current location
    var locationManager:CLLocationManager!
    
    /// Declares if the map is zoomed in or zoomed out
    var zoomedOut : Bool = false
    
    /// Speach Synthesizer for the acoustic information output
    var synthesizer = AVSpeechSynthesizer()
    
    /// Array of Parking Lot objects
    var parkingLots : [ParkingLot] = []
    
    /// Defaults to store the user settings
    let defaults = UserDefaults.standard
    
    /// A timer to update the map
    var timer : Timer!
    
    /// App Delegate
    var appDelegate : AppDelegate?
    
    // MARK: IBOutlet Properties

    /// Outlet for the  Menu Button to show the Side Menu
    @IBOutlet weak var showMenuButton: UIBarButtonItem!
    
    /// Outlet for the Map View to show the Map of Amberg
    @IBOutlet weak var mapViewArea: GMSMapView!
    
    /// Outlet for the voice switch
    @IBOutlet weak var voiceSwitch: UIButton!
    
    /// Outlet for the favorites switch
    @IBOutlet weak var favSwitch: UIButton!
    
    /// Outlet for the location switch
    @IBOutlet weak var locationSwitch: UIButton!
    
    /// Outlet for the Label to provides the time for the last update
    @IBOutlet weak var lastUpdated: UILabel!




    
    // MARK: Default View Controller Methods

    /**
        Provides the start point when the view loads.
     
        - set the Camera Postion
        - delegates for map view updates
        - loads default settings
    */
    override func loadView() {
        
        // load the view super class
        super.loadView()
        
        // Set Current Camera Location for G Maps
        let camera = GMSCameraPosition.camera(withLatitude: 49.445273, longitude: 11.857122, zoom: InitMap.zoom!)
        
        // set map view camera
        mapViewArea.camera = camera
        
        // set delegate for updates
        mapViewArea.delegate = self
        
        // set my location enabled
        mapViewArea.isMyLocationEnabled = true
        
        // standard zoomed out
        self.zoomedOut = true
        
        // load default settings
        self.default_settings()
    
    }
    
    /**
        After the View did load do the following tasks:
     
        - load the SWR Side Menu
        - setup the location Service
        - get the shared App Delegate to load the parkin lots
        - set the status for the buttons depending on the user settings
        - load and update Markers
        - set timer to update the view
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SWR Menu
        if self.revealViewController() != nil {
            showMenuButton.target = self.revealViewController()
            showMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Location Service
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // Load parking lots
        appDelegate = UIApplication.shared.delegate as! AppDelegate?
        self.parkingLots = (appDelegate?.parkingLots)!
        
        // Set Voice Buttons
        if defaults.object(forKey: "voiceSwitch") != nil{
            if defaults.bool(forKey: "voiceSwitch") == true {
                self.voiceSwitch.setImage(#imageLiteral(resourceName: "speakingOn"), for: UIControlState.normal)
                self.voiceSwitch.tag = 1
            }
            else{
                self.voiceSwitch.setImage(#imageLiteral(resourceName: "speakingOff"), for: UIControlState.normal)
                self.voiceSwitch.tag = 0
            }
        }else {
            self.voiceSwitch.tag = 0
        }
        
        // Set Favorite Buttons
        if defaults.object(forKey: "favoritesSwitch") != nil{
            
            if defaults.bool(forKey: "favoritesSwitch") == true {
                self.favSwitch.setImage(#imageLiteral(resourceName: "favOn"), for: UIControlState.normal)
                self.favSwitch.tag = 1
            }
            else{
                self.favSwitch.setImage(#imageLiteral(resourceName: "favOff"), for: UIControlState.normal)
                self.favSwitch.tag = 0
            }
        }
        else {
            self.favSwitch.tag = 0
        }
        
        //Get Markers
        self.loadAndUpdateMarkers()
        
        //Set Timer
        timer = Timer.scheduledTimer(withTimeInterval: InitMap.udpateTimer!, repeats: true, block: {_ in
            self.loadAndUpdateMarkers()
        })
        
    }
    
    /**
        Reset the Location Manager Delegate, Map View Area Delegate and the Timer
    */
    override func viewDidDisappear(_ animated: Bool) {
        self.locationManager.delegate = nil
        self.mapViewArea.delegate = nil
        timer.invalidate()
    }

    
    // MARK: IBAction Methods

    /**
        Action to toggle the voice on/off
    */
    @IBAction func voiceSwitch(_ sender: Any) {
        
        if self.voiceSwitch.tag == 1 {
            defaults.set(false, forKey: "voiceSwitch")
            self.voiceSwitch.setImage(#imageLiteral(resourceName: "speakingOff"), for: UIControlState.normal)
            self.voiceSwitch.tag = 0
        }
        else {
            defaults.set(true, forKey: "voiceSwitch")
            self.voiceSwitch.setImage(#imageLiteral(resourceName: "speakingOn"), for: UIControlState.normal)
            self.voiceSwitch.tag = 1
        }
    }
    
    /**
        Action to toggle the favorites on/off
    */
    @IBAction func favSwitch(_ sender: Any) {
        if self.favSwitch.tag == 1 {
            defaults.set(false, forKey: "favoritesSwitch")
            self.favSwitch.setImage(#imageLiteral(resourceName: "favOff"), for: UIControlState.normal)
            self.favSwitch.tag = 0
        }
        else {
            defaults.set(true, forKey: "favoritesSwitch")
            self.favSwitch.setImage(#imageLiteral(resourceName: "favOn"), for: UIControlState.normal)
            self.favSwitch.tag = 1
        }
        loadAndUpdateMarkers()
    }
    /**
        Action to toggle the current location on/off
    */
    @IBAction func locationSwitch(_ sender: Any) {
        if self.locationSwitch.tag == 1 {
            self.locationSwitch.setImage(#imageLiteral(resourceName: "locationOff"), for: UIControlState.normal)
            self.locationSwitch.tag = 0
        }
        else {
            self.locationSwitch.setImage(#imageLiteral(resourceName: "locationOn"), for: UIControlState.normal)
            self.locationSwitch.tag = 1
        }
    }
    /**
        Action to refresh the Map.
        The Function `loadAndUpdateMarkers()` gets called
    */
    @IBAction func refreshMap(_ sender: Any) {
        loadAndUpdateMarkers()
    }
    
    
    // MARK: Delegate Methods

    
    /**
        This function gets called every time the position updates.
        It calculates the distance between the user and a parking lot. If the user is in the radius of `InitMap.zoomDistance` then the following actions get triggert depending on the user settings:
     
        - Automatic zoom in and out
        - Shows a toast on the screen with the name of the parking lot
        - Provides acoustic information (e.g. amount of free parking lots, opening and closing time, 24h parking fee)
     
        ## Important Notes ##
        - This function gets called automatically
        - If there are more than one parking lot in the user radius simultaneously then the closest one will get picked and the zoom gets locked till no parking lot is in the user radius
    */
    

    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var zoomCount : Int = 0;
        for (_	, pLot) in self.parkingLots.enumerated(){
            if !(self.defaults.object(forKey: "favoritesSwitch") as! Bool == true && self.defaults.bool(forKey: "favoritesSwitch") == true && pLot.isFavVisible == false || pLot.closed == 1){
                let parkingLotCoordinate = CLLocation(latitude: pLot.location.latitude, longitude: pLot.location.longitude)
                if Int((locations.last?.distance(from: parkingLotCoordinate))!) < InitMap.zoomDistance! {
                    zoomCount += 1
                    if !pLot.gotZoomed && zoomCount <= 1 {
                        
                        if self.defaults.object(forKey: "zoomSwitch") != nil{
                            if self.defaults.bool(forKey: "zoomSwitch") == true {
                                mapViewArea?.animate(toLocation: CLLocationCoordinate2D(latitude: pLot.location.latitude, longitude: pLot.location.longitude))
                                mapViewArea?.animate(toZoom: 17)
                            }
                        }
                        pLot.gotZoomed = true
                        self.zoomedOut = false
                        
                        showToast(withMessage: pLot.name)
                        if self.defaults.object(forKey: "voiceSwitch") != nil{
                            if self.defaults.bool(forKey: "voiceSwitch") == true {

                                let now = Date()
                                let openToday = now.dateAt(date: pLot.costOpening)
                                let closeToday = now.dateAt(date: pLot.costClosing)
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "HH"
                                var parkingFeeString : String = ""
                                
                                if !pLot.is24hFeeBased {
                                     parkingFeeString = " und wird ab "
                                    if now >= openToday &&
                                        now <= closeToday
                                    {
                                        parkingFeeString += dateFormatter.string(from: pLot.costClosing) + " Uhr kostenlos"
                                    }
                                    else{
                                        //und wird ab 9.00 Uhr kostenpflichtig
                                        
                                        parkingFeeString += dateFormatter.string(from: pLot.costOpening) + " Uhr wieder kostenpflichtig"
                                    }
                                }
                                var capazityString : String = String(pLot.capazity) + " Plätze"
                                
                                if pLot.capazity == 1 {
                                    capazityString = "ein Platz"
                                }
                                
                                let text : String = "Parkhaus: " + String(pLot.name) + ", " + capazityString + " frei" + String(parkingFeeString)
                                let utterance = AVSpeechUtterance(string: text)
                                utterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
                                synthesizer.speak(utterance)
                            }
                        }
                        
                    }
                }else {
                    pLot.gotZoomed = false
                }
            }
        }
        
        if !self.zoomedOut && zoomCount == 0{
            if self.defaults.object(forKey: "zoomSwitch") != nil{
                if self.defaults.bool(forKey: "zoomSwitch") == true {
                    mapViewArea?.animate(toLocation: CLLocationCoordinate2D(latitude: InitMap.latitude!, longitude: InitMap.longitude!))
                    mapViewArea?.animate(toZoom: InitMap.zoom!)
                }
            }
            self.zoomedOut = true
        }
        if self.locationSwitch.tag == 1 {
            mapViewArea?.animate(toLocation: (locations.last?.coordinate)!)
        }
        
    }

    /**
        This function gets called every time the user manually moves the Map in the View.

        - resets the current location service
    */
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture{
            self.locationSwitch.setImage(#imageLiteral(resourceName: "locationOff"), for: UIControlState.normal)
            self.locationSwitch.tag = 0
        }
    }
    /**
        This function overrides the Info Window View
        
        If the User taps on a parking lot the `InfoWindowView` will show up
     
    */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let customInfoWindowView = InfoWindowView.instanceFromNib(withPLotName: marker.title!)
        return customInfoWindowView
    }
    /**
        This function overrides the Did Tap Info Window
        
        If the User taps on a parking lot info window google maps will be started. The Destination is the position of the tapped parking lot. The source is the user location
     
    */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let lat = marker.position.latitude
        let lon = marker.position.longitude
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(lat),\(lon)&directionsmode=driving")!as URL, options: [:], completionHandler: nil)
        } else {
            if (UIApplication.shared.canOpenURL(NSURL(string:"https://maps.google.com")! as URL)) {
                UIApplication.shared.open(NSURL(string:
                    "https://maps.google.com/?q=@\(lat),\(lon)")! as URL, options: [:], completionHandler: nil)
                
            }
        }
    }
    /**
         This function gets called every time the user taps on a marker.

        - resets the current location service
     
    */
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.locationSwitch.setImage(#imageLiteral(resourceName: "locationOff"), for: UIControlState.normal)
        self.locationSwitch.tag = 0
        return false
    }

    // MARK: Custom Methods
    /**
        Shows a Toast-Message on the Screen for 7.5 seconds

        - parameter withMessage: The string you want to show in the Toast-Message

        - returns: None
    */
    func showToast(withMessage: String){
        let toastLabel = UILabel(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-100, width: UIScreen.main.bounds.width, height: 35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center;
        self.mapViewArea.addSubview(toastLabel)
        toastLabel.text = withMessage
        toastLabel.alpha = 0.9
        toastLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 1.5, delay: 6.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        })
    }
    
    /**
        The Method is downloading the XML from the Website.

        - [Parking XML Amberg](http://parken.amberg.de/wp-content/uploads/pls/pls.xml):

        - returns: None
        
        ## Important Notes ##
        - If there is no internet connection the Method tries to load the last downloaded data.
        - The data load from the website is asynchronic to avoid a UI Freeze
     

    */
    func getXMLDrawMarkers(){
        
        let url:String="http://parken.amberg.de/wp-content/uploads/pls/pls.xml"
        let urlToSend: URL = URL(string: url)!
        let request = NSMutableURLRequest(url: urlToSend)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        //Async download
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            // if download failes and there is no existing data then draw basic markers
            if data == nil && self.appDelegate?.parkingLotData == nil{
                print("dataTaskWithRequest error: \(error)")
                DispatchQueue.main.async(){
                    self.drawBasicMarkersOnly()
                    self.showToast(withMessage: "Keine Internet-Verbindung!")
                }
                return
            }

            // Save downloaded data
            if data != nil {
                self.appDelegate?.parkingLotData = data
            }

            // Parsing Data Async
            DispatchQueue.main.async {
                self.parseXML()
            }
        }
        task.resume()

    }
    /**
        The Method is Parsing the XML from the Website and drawing the Markers in the Map. It also updates the `lastUpdated` label.

        - returns: None
        
        ## Important Notes ##
        - Depending on the user settings (favorites, style view) the parking lots will be shown or not.
     

    */
    func parseXML(){
        let xml = SWXMLHash.parse((self.appDelegate?.parkingLotData)!)
        
        if let definition = xml["Daten"]["Zeitstempel"].element?.text {
            self.lastUpdated.text = "Stand: \(definition)"
        }
        
        for elem in xml["Daten"]["Parkhaus"].all {
            for (_	, pLot) in self.parkingLots.enumerated(){
                if (pLot.xmlID == Int(elem["ID"].element!.text!)!){
                    pLot.capazity = Int(elem["Frei"].element!.text!)!
                    pLot.name = elem["Name"].element!.text!
                    pLot.trend = Int(elem["Trend"].element!.text!)!
                    pLot.status = elem["Status"].element!.text!
                    pLot.closed = Int(elem["Geschlossen"].element!.text!)!
                }
            }
            
        }
        
        //reload data after fetch
        self.mapViewArea.clear()
        
        //check if parking lot is visible or not
        for (_	, pLot) in self.parkingLots.enumerated(){
            pLot.isFavVisible = true
            if self.defaults.object(forKey: "favoritesSwitch") != nil{
                if self.defaults.bool(forKey: "favoritesSwitch") == true {
                    if self.defaults.object(forKey: "xmlID"+String(pLot.xmlID)) != nil{
                        if self.defaults.bool(forKey: "xmlID"+String(pLot.xmlID)) == false {
                            pLot.isFavVisible = false
                        }
                    }
                }
            }
            
            //for each visible lot draw a marker
            if pLot.isFavVisible{
                let customMarkerView = CustomMarkerView.instanceFromNib(withParkingSpots: pLot.capazity, parkingTrend:pLot.trend, markerNumber: pLot.xmlID,isClosed: pLot.closed,open: pLot.costOpening, close: pLot.costClosing,fee: pLot.pricePerHour,is24FeeBased: pLot.is24hFeeBased)
                let normalMarkerView = NormalMarkerView.instanceFromNib(withParkingSpots: pLot.capazity, parkingTrend:pLot.trend, markerNumber: pLot.xmlID,isClosed: pLot.closed,fee: pLot.pricePerHour)
                let pLotMarker = GMSMarker()
                pLotMarker.position = CLLocationCoordinate2D(latitude: pLot.location.latitude, longitude: pLot.location.longitude)
                pLotMarker.title = pLot.name
                pLotMarker.map = self.mapViewArea
                if self.defaults.object(forKey: "detailsSwitch") != nil{
                    if self.defaults.bool(forKey: "detailsSwitch") == true {
                        pLotMarker.iconView = customMarkerView
                    }
                    else{
                        pLotMarker.iconView = normalMarkerView//customMarkerView
                    }
                }
                pLotMarker.isFlat = false
            }
        }
    }
    
    /**
        The Method provides basic markers which have less information than a Detail- and None-Detail-Marker.
        These Markers are used if there is no internet connection and `appDelegate.parkingLotData` is empty

        - returns: None
     
    */
    func drawBasicMarkersOnly(){
        self.mapViewArea.clear()
        //check if parking lot is visible or not
        for (_	, pLot) in self.parkingLots.enumerated(){
            pLot.isFavVisible = true
            if self.defaults.object(forKey: "favoritesSwitch") != nil{
                if self.defaults.bool(forKey: "favoritesSwitch") == true {
                    if self.defaults.object(forKey: "xmlID"+String(pLot.xmlID)) != nil{
                        if self.defaults.bool(forKey: "xmlID"+String(pLot.xmlID)) == false {
                            pLot.isFavVisible = false
                        }
                    }
                }
            }
            
            
            if pLot.isFavVisible{
                let customMarkerView = CustomMarkerView.instanceFromNibNoInetNoData(withNumber:pLot.xmlID)
                let normalMarkerView = NormalMarkerView.instanceFromNibNoInetNoData(withNumber:pLot.xmlID)
                let pLotMarker = GMSMarker()
                pLotMarker.position = CLLocationCoordinate2D(latitude: pLot.location.latitude, longitude: pLot.location.longitude)
                pLotMarker.title = pLot.name
                pLotMarker.map = self.mapViewArea
                if self.defaults.object(forKey: "detailsSwitch") != nil{
                    if self.defaults.bool(forKey: "detailsSwitch") == true {
                        pLotMarker.iconView = customMarkerView
                    }
                    else{
                        pLotMarker.iconView = normalMarkerView//customMarkerView
                    }
                }
                pLotMarker.isFlat = false
            }
        }
    }

    /**
        The Method triggers the `getXMLDrawMarkers()` Method to refresh the Data

        - returns: None
     
    */
    func loadAndUpdateMarkers(){
        if isInternetAvailable() == true || self.appDelegate?.parkingLotData != nil{
            getXMLDrawMarkers()
            if !isInternetAvailable(){
                self.showToast(withMessage: "Keine Internet-Verbindung!")
            }
        }else {
            drawBasicMarkersOnly()
            self.showToast(withMessage: "Keine Internet-Verbindung!")
        }
        
    }
    
    /**
        The Method checks if there is a internet connection
     
        - returns: True if Available, Flase if not
     
    */
    func isInternetAvailable() -> Bool
    {
        //http://stackoverflow.com/questions/39558868/check-internet-connection-ios-10
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    /**
        The Method sets the default values for the user settings

        - returns: None
     
    */
    func default_settings(){
        if defaults.object(forKey: "voiceSwitch") == nil{
            defaults.set(true, forKey: "voiceSwitch")
        }
    
        if defaults.object(forKey: "favoritesSwitch") == nil{
            defaults.set(false, forKey: "favoritesSwitch")
        }
        
        if defaults.object(forKey: "zoomSwitch") == nil{
            defaults.set(true, forKey: "zoomSwitch")
        }
        
        if defaults.object(forKey: "detailsSwitch") == nil{
            defaults.set(true, forKey: "detailsSwitch")
        }
    }
}


extension Date
{
    /**
        Returns a date with the hours and minutes from the date parameter

        - parameter date: The date with the hours and minutes

        - returns: The new Date with the hour and mintues from the date parameter
    */
    func dateAt(date : Date) -> Date
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var hours = 0
        var minutes = 0
        calendar.getHour(&hours, minute: &minutes, second: nil, nanosecond: nil, from: date)

        
        
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
}




