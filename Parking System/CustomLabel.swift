//
//  CustomLabel.swift
//  Parking System
//
//  Created by Tobias on 07/12/2016.
//  Copyright © 2016 Tobias. All rights reserved.
//

import UIKit
/**
    A custom `UILabel` for the Background of the Marker
 
*/
class CustomLabel: UILabel {

    /**
        Draw function for a black custom background with rounded corners
    */
    override func draw(_ rect: CGRect) {
            // Size of rounded rectangle
            let rectHeight:CGFloat = 60
            let rectWidth:CGFloat = 40
            
            // Find center of actual frame to set rectangle in middle
            let xf:CGFloat = (self.frame.width  - rectWidth)  / 2
            let yf:CGFloat = (self.frame.height - rectHeight) / 2
            
            let ctx: CGContext = UIGraphicsGetCurrentContext()!
            ctx.saveGState()
            
            let rect = CGRect(x: xf, y: yf, width: rectWidth, height: rectHeight)
            let clipPath: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: 8).cgPath
            
            ctx.addPath(clipPath)
            ctx.setFillColor(UIColor.black.cgColor)
            self.alpha = 0.8

            
            ctx.closePath()
            ctx.fillPath()
            ctx.restoreGState()
        
    }
 

}
