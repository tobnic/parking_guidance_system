//
//  NormalMarkerView.swift
//  Parking System
//
//  Created by Tobias on 08/12/2016.
//  Copyright © 2016 Tobias. All rights reserved.
//

import UIKit
/**
    Provides a standard custom marker for the parking lots
*/
class NormalMarkerView: UIView {
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
    
    /// Shows the parking fee
    @IBOutlet weak var feeLabel: UILabel!
    
    
    // MARK: Custom Class Function

    /**
        Provides an instance from the Custom Maps Marker Nib.

        - parameter withParkingSpots: The number of free parking spots
        - parameter parkingTrend: The parking Trend 0:down 1:up
        - parameter markerNumber: The number of the Marker
        - parameter isClosed: If the parking lot is closed 1 otherwise 0
        - parameter fee: The fee for the parking lot
     
        - returns: Custom Marker View from `UINib` as 'UIView'
    */
    class func instanceFromNib(withParkingSpots : Int, parkingTrend : Int, markerNumber : Int, isClosed: Int, fee: String) -> UIView {
        
        let myCustomView:NormalMarkerView = UINib(nibName: "normalMarker", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NormalMarkerView
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        
        myCustomView.markerNumber.text = String(markerNumber)

        myCustomView.feeLabel.text = String(fee) + " €"
        
        
        
        if isClosed == 1{
            myCustomView.closedIcon.isHidden = false
            myCustomView.parkingTrendDown.isHidden = true
            myCustomView.parkingTrendUp.isHidden = true
            myCustomView.counterLabel.isHidden = true
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
        let myCustomView:NormalMarkerView = UINib(nibName: "normalMarker", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NormalMarkerView

        myCustomView.closedIcon.isHidden = false
        myCustomView.closedIcon.image = UIImage(named: "Pimage")?.withRenderingMode(.alwaysTemplate)
        myCustomView.closedIcon.tintColor = UIColor.white
        myCustomView.parkingTrendDown.isHidden = true
        myCustomView.parkingTrendUp.isHidden = true
        myCustomView.counterLabel.isHidden = true
         myCustomView.markerNumber.text = String(withNumber)
        return myCustomView
    }


}
