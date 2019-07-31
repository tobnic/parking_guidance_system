//
//  InfoWindowView.swift
//  Parking System
//
//  Created by Tobias on 09/12/2016.
//  Copyright © 2016 Tobias. All rights reserved.
//

import UIKit
/**
    Provides a Info Window View for the Marker on a Map
*/
class InfoWindowView: UIView {

    // MARK: IBOutlet Properties
    
    /// Shows the background label of the info window
    @IBOutlet weak var backgroundInfoLabel: UILabel!
    
    /// Shows the parking lot name label
    @IBOutlet weak var parkingLotName: UILabel!
    
    // MARK: Custom Class Function
    
    /**
        Provides an instance from the Info Window Nib with a parking lot name.

        - parameter withPLotName: The name of the Parking Lot
     
        - returns: Custom Info Window View for the Marker on a Map from `UINib` as 'UIView'
    */
    class func instanceFromNib(withPLotName: String) -> UIView {
        
        let myCustomView:InfoWindowView = UINib(nibName: "InfoWindow", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! InfoWindowView
        
        myCustomView.backgroundInfoLabel.layer.masksToBounds = true
        myCustomView.backgroundInfoLabel.layer.cornerRadius = 5
        myCustomView.parkingLotName.text = withPLotName
        
        return myCustomView
    }


}
