//
//  SettingsViewController.swift
//  Parking System
//
//  Created by Tobias on 07/12/2016.
//  Copyright © 2016 Tobias. All rights reserved.
//

import UIKit
/**
    Provides and stores the user settings
*/
class SettingsViewController: UIViewController {

    // MARK: IBOutlet Properties

    /// Outlet for the voice switch
    @IBOutlet weak var voiceSwitch: UISwitch!
    
    /// Outlet for the favorites switch
    @IBOutlet weak var favoritesSwitch: UISwitch!
    
    /// Outlet for the auto zoom
    @IBOutlet weak var zoomSwitch: UISwitch!
    
    /// Outlet for the detail view marker
    @IBOutlet weak var detailsSwitch: UISwitch!
    
    /// Outlet for the menu button
    @IBOutlet weak var showMenuButton: UIBarButtonItem!
    
    // MARK: IBAction Methods    
    /**
        Action to toggle the voice on/off and store in the user settings with the key voiceSwitch
    */
    @IBAction func voiceSwitch(_ sender: Any) {
        let defaults = UserDefaults.standard
        if self.voiceSwitch.isOn {
            defaults.set(true, forKey: "voiceSwitch")
        }
        else {
            defaults.set(false, forKey: "voiceSwitch")
        }
    }
    /**
        Action to toggle the favorites on/off and store in the user settings with the key favoritesSwitch
    */
    @IBAction func favoritesSwitch(_ sender: Any) {
        let defaults = UserDefaults.standard
        if self.favoritesSwitch.isOn {
            defaults.set(true, forKey: "favoritesSwitch")
        }
        else {
            defaults.set(false, forKey: "favoritesSwitch")
        }
    }
    /**
        Action to toggle the auto zoom on/off and store in the user settings with the key zoomSwitch
    */
    @IBAction func zoomSwitch(_ sender: Any) {
        let defaults = UserDefaults.standard
        if self.zoomSwitch.isOn {
            defaults.set(true, forKey: "zoomSwitch")
        }
        else {
            defaults.set(false, forKey: "zoomSwitch")
        }
    }
    /**
        Action to toggle the detail view marker on/off and store in the user settings with the key detailsSwitch
    */
    @IBAction func detailSwitch(_ sender: Any) {
        let defaults = UserDefaults.standard
        if self.detailsSwitch.isOn {
            defaults.set(true, forKey: "detailsSwitch")
        }
        else {
            defaults.set(false, forKey: "detailsSwitch")
        }
    }
    
     // MARK: Default View Controller Methods
       /**
        After the View did load do the following tasks:
     
        - load the SWR Side Menu
        - load the user settings and set the switches
     
        */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SWR Menu
        if self.revealViewController() != nil {
            showMenuButton.target = self.revealViewController()
            showMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let defaults = UserDefaults.standard

        if defaults.object(forKey: "voiceSwitch") != nil{
            self.voiceSwitch.setOn(defaults.bool(forKey: "voiceSwitch"), animated: false)
        }
        
        if defaults.object(forKey: "favoritesSwitch") != nil{
            self.favoritesSwitch.setOn(defaults.bool(forKey: "favoritesSwitch"), animated: false)
        }
        
        if defaults.object(forKey: "zoomSwitch") != nil{
            self.zoomSwitch.setOn(defaults.bool(forKey: "zoomSwitch"), animated: false)
        }
        
        if defaults.object(forKey: "detailsSwitch") != nil{
            self.detailsSwitch.setOn(defaults.bool(forKey: "detailsSwitch"), animated: false)
        }
        
        
    }
   /**
    Did Receive Memory Warning
 
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
