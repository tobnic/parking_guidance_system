//
//  CustomMarkerView.swift
//  Parking System
//
//  Created by Tobias on 03/12/2016.
//  Copyright © 2016 Tobias. All rights reserved.
//


import UIKit
/**
    Provides a detail custom marker for the parking lots
*/
class CustomMarkerView: UIView {
    
    // MARK: IBOutlet Properties

    /// Shows the number of free parking lots
    @IBOutlet weak var counterLabel: UILabel!
    
    /// Shows the number of the marker
    @IBOutlet weak var markerNumber: UILabel!
    
    /// Shows a rising parking the trend
    @IBOutlet weak var parkingTrendDown: UIImageView!
    
    /// Shows a falling parking the trend
    @IBOutlet weak var parkingTrendUp: UIImageView!
    
    /// Shows if the parking lot is closed
    @IBOutlet weak var closedIcon: UIImageView!
    
    /// Shows if the "minus" betwenn opening and closing time
    @IBOutlet weak var minusLabel: UILabel!
    
    /// Shows the opening time for the parking fee
    @IBOutlet weak var feeOpening: UILabel!
    
    /// Shows the closing time for the parking fee
    @IBOutlet weak var feeClosing: UILabel!
    
    /// Shows the parking fee
    @IBOutlet weak var feeLabel: UILabel!
    
    /// Shows background label
    @IBOutlet weak var bgLabel: UILabel!
    
    /// Shows the euro label
    @IBOutlet weak var euroLabel: UILabel!
    
    /// Shows the parking label
    @IBOutlet weak var parkingCarLabel: UIImageView!
    
    // MARK: Custom Class Function


    /**
        Provides an instance from the Custom Maps Marker Nib.

        - parameter withParkingSpots: The number of free parking spots
        - parameter parkingTrend: The parking Trend 0:down 1:up
        - parameter markerNumber: The number of the Marker
        - parameter isClosed: If the parking lot is closed 1 otherwise 0
        - parameter open: The opening time
        - parameter close: The closing time
        - parameter fee: The fee for the parking lot
        - parameter is24FeeBased: If parking is 24 fee-based then 1 otherwise 0
     
        - returns: Custom Marker View from `UINib` as 'UIView'
    */
    class func instanceFromNib(withParkingSpots : Int, parkingTrend : Int, markerNumber : Int, isClosed: Int, open: Date, close : Date, fee: String, is24FeeBased : Bool) -> UIView {
        
        let myCustomView:CustomMarkerView = UINib(nibName: "mapsMarker", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomMarkerView
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        
        myCustomView.markerNumber.text = String(markerNumber)
        if(is24FeeBased){
            myCustomView.feeClosing.frame = CGRect(x: myCustomView.feeClosing.frame.origin.x-10, y:myCustomView.feeClosing.frame.origin.y , width: 15, height: myCustomView.feeClosing.frame.height)
            myCustomView.feeOpening.isHidden = true
            myCustomView.minusLabel.isHidden = true

            myCustomView.feeClosing.text = "24h"
        }else {
            myCustomView.feeClosing.text = dateFormatter.string(from: close)
            myCustomView.feeOpening.text = dateFormatter.string(from: open)
        }
        
        myCustomView.feeLabel.text = fee

    
        
        if isClosed == 1{
            myCustomView.closedIcon.isHidden = false
            myCustomView.parkingTrendDown.isHidden = true
            myCustomView.closedIcon.image = UIImage(named: "closedIcon")?.withRenderingMode(.alwaysOriginal)
            myCustomView.parkingTrendUp.isHidden = true
            myCustomView.counterLabel.isHidden = true
            myCustomView.feeLabel.isHidden = true
            myCustomView.feeClosing.isHidden = true
            myCustomView.feeOpening.isHidden = true
            myCustomView.minusLabel.isHidden = true
            myCustomView.euroLabel.isHidden = true
            myCustomView.parkingCarLabel.isHidden = true
        }else{
            myCustomView.closedIcon.isHidden = true;
    
            if parkingTrend == 1 {
                myCustomView.parkingTrendDown.isHidden = false
                myCustomView.parkingTrendUp.isHidden = true

                myCustomView.parkingTrendDown.image = #imageLiteral(resourceName: "arrowDown") // D10606
            }else if parkingTrend == -1{
                myCustomView.parkingTrendDown.isHidden = true
                myCustomView.parkingTrendUp.isHidden = false

                myCustomView.parkingTrendUp.image = #imageLiteral(resourceName: "arrowUp") //1BB32A
            }else{
                myCustomView.parkingTrendDown.isHidden = true
                myCustomView.parkingTrendUp.isHidden = true
                myCustomView.counterLabel.frame = CGRect(x: myCustomView.counterLabel.frame.origin.x, y: myCustomView.counterLabel.frame.origin.y, width: 40, height: myCustomView.counterLabel.frame.height)
                myCustomView.counterLabel.textAlignment = NSTextAlignment.center
            }
            
            myCustomView.counterLabel.text = String(withParkingSpots)
            
            myCustomView.parkingTrendDown.alpha = 0
            myCustomView.parkingTrendUp.alpha = 0
            UIView.animate(withDuration: 1.5, delay: 0.3, options: [.repeat, .curveEaseOut, .autoreverse], animations: {myCustomView.parkingTrendUp.alpha = 1; myCustomView.parkingTrendDown.alpha = 1}, completion: nil)

            //UINib(nibName: "mapsMarker", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        }
        return myCustomView
    }
    
    /**
        Provides an instance from the Custom Maps Marker Nib only with the marker number


        - parameter withNumber: The number of the Marker
        - returns: Custom Marker View from `UINib` as 'UIView'
    */
    class func instanceFromNibNoInetNoData(withNumber: Int) -> UIView {
        
        let myCustomView:CustomMarkerView = UINib(nibName: "mapsMarker", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomMarkerView

            myCustomView.closedIcon.isHidden = false
            myCustomView.closedIcon.image = UIImage(named: "Pimage")?.withRenderingMode(.alwaysTemplate)
            myCustomView.closedIcon.tintColor = UIColor.white
            myCustomView.parkingTrendDown.isHidden = true
            myCustomView.parkingTrendUp.isHidden = true
            myCustomView.counterLabel.isHidden = true
            myCustomView.feeLabel.isHidden = true
            myCustomView.feeClosing.isHidden = true
            myCustomView.feeOpening.isHidden = true
            myCustomView.minusLabel.isHidden = true
            myCustomView.euroLabel.isHidden = true
            myCustomView.parkingCarLabel.isHidden = true
            myCustomView.markerNumber.text = String(withNumber)

        return myCustomView
    }
    
}
