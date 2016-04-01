//
//  SettingsTableViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/29/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

public enum SettingsKey: String {
    case CS = "major"
    case AI = "AI"
    case Renaissance = "Renaissance"
    case CSE = "CSE"
    case Graphics = "Graphics"
    case NS = "NS"
    case PL = "PL"
    case SE = "SE"
    case SD = "SD"
    case Theory = "Theory"
}

protocol SettingsDelegate {
    func handleToggle(cell: SettingsTableViewCell)
}

class SettingsTableViewController: UITableViewController, SettingsDelegate {

    var reqsAndTogglesAndKeys: [(Requirement, Bool, SettingsKey)]!
    var settings: [String: Bool]!
    var defaults: NSUserDefaults!
    let vectorNum = 10
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        tableView.backgroundColor = .blackColor()
        tableView.registerNib(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        navigationItem.title = "Settings"
        addRevealVCButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return vectorNum
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath) as! SettingsTableViewCell
        cell.delegate = self
        cell.settingLabel.text = reqsAndTogglesAndKeys[indexPath.row].0.title
        cell.settingLabel.adjustsFontSizeToFitWidth = true
        cell.toggleSwitch.on = reqsAndTogglesAndKeys[indexPath.row].1
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(65)
    }
    
    func handleToggle(cell: SettingsTableViewCell) {
        let indexPath = tableView.indexPathForCell(cell)
        let row = indexPath!.row
        reqsAndTogglesAndKeys[row].1 = !(reqsAndTogglesAndKeys[row].1)
        settings[reqsAndTogglesAndKeys[row].2.rawValue] = reqsAndTogglesAndKeys[row].1
        defaults.setBool(reqsAndTogglesAndKeys[row].1, forKey: reqsAndTogglesAndKeys[row].2.rawValue)
    }
}
