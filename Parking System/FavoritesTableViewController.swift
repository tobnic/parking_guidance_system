//
//  FavoritesTableViewController.swift
//  Parking System
//
//  Created by Tobias on 07/12/2016.
//  Copyright © 2016 Tobias. All rights reserved.
//

import UIKit
/**
    Provides the tabel view for the Favorite Table
*/
class FavoritesTableViewController: UITableViewController {
    // MARK: IBOutlet Properties
    @IBOutlet weak var showMenuButton: UIBarButtonItem!
    
    // MARK: Properties
    /// Array of Parking Lot objects
    var parkingLots : [ParkingLot] = []
    
    /// Defaults to store the user settings
    let defaults = UserDefaults.standard

    /**
        After the View did load do the following tasks:
     
        - load the SWR Side Menu
        - get the shared App Delegate to load the parkin lots
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SWR Menu
        if self.revealViewController() != nil {
            showMenuButton.target = self.revealViewController()
            showMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.parkingLots = appDelegate.parkingLots

    }
    /**
        Did Receive Memory Warning

    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /**
        Number of Sections in the Table

        - returns: Number of Sections in the Table
    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /**
        Number of Rows in the section

        - returns: Number of parking lots
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.parkingLots.count
    }

    /**
        Fills the Table View Cell with the name of the parking lot and the option settings

        - returns: Favorite Table View Cell with the name of a parking lot
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! FavTableViewCell
        cell.textLabelFavorite?.text = parkingLots[indexPath.row].name
        if defaults.object(forKey: "xmlID"+String(parkingLots[indexPath.row].xmlID)) != nil{
            cell.switchFavorite.setOn(defaults.bool(forKey: "xmlID"+String(parkingLots[indexPath.row].xmlID)), animated: false)
        }
        cell.switchFavorite.tag = parkingLots[indexPath.row].xmlID
        cell.switchFavorite.addTarget(self,action: #selector(FavoritesTableViewController.buttonFavoriteAction(sender:)), for: .touchUpInside)

        return cell
    }
    
    /**
        Store the action "on" or "off" in the user settings 
        - parameter  sender: The UISwitch which triggert the action
    */
    func buttonFavoriteAction(sender: UISwitch!) {
        print(sender.tag)
        
        if sender.isOn {
            defaults.set(true, forKey: "xmlID"+String(sender.tag))
        }
        else {
            defaults.set(false, forKey: "xmlID"+String(sender.tag))
        }
    }

}

/**
    Provides the tabel view cell for the Favorite Table
*/
class FavTableViewCell: UITableViewCell {
    // MARK: IBOutlet Properties
    /// Shows the text for parkin lot in the table
    @IBOutlet weak var textLabelFavorite: UILabel!
    /// Shows the on/off switch for parking lot in the table
    @IBOutlet weak var switchFavorite: UISwitch!
    
}
