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
}

protocol SettingsDelegate {
    func handleToggle(cell: SettingsTableViewCell)
}

class SettingsTableViewController: UITableViewController, SettingsDelegate {
    
    var CSToggled: Bool!
    var AItoggled: Bool!
    var renaissanceToggled: Bool!
    
    var settings: [String: Bool]!
    var defaults: NSUserDefaults!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        tableView.backgroundColor = .blackColor()
        tableView.registerNib(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        navigationItem.title = "Settings"
        setupToggles()
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
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath) as! SettingsTableViewCell
        cell.delegate = self
        let settingsDescription: String
        let onOrOff: Bool
        switch (indexPath.row) {
        case 0:
            settingsDescription = "CS Requirements (Major Requirement)"
            onOrOff = settings[SettingsKey.CS.rawValue]!
        case 1:
            settingsDescription = "Artificial Intelligence (Vector)"
            onOrOff = settings[SettingsKey.AI.rawValue]!
        case 2:
            settingsDescription = "Renaissance (Vector)"
            onOrOff = settings[SettingsKey.Renaissance.rawValue]!
        default:
            settingsDescription = ""
            onOrOff = false
        }
        cell.settingLabel.text = settingsDescription
        cell.toggleSwitch.on = onOrOff
        return cell
    }
    
    func setupToggles() {
        settings[SettingsKey.CS.rawValue] = CSToggled
        settings[SettingsKey.AI.rawValue] = AItoggled
        settings[SettingsKey.Renaissance.rawValue] = renaissanceToggled
    }
    
    func handleToggle(cell: SettingsTableViewCell) {
        let indexPath = tableView.indexPathForCell(cell)
        var desiredToggle: Bool
        var desiredKey: SettingsKey
        switch(indexPath!.row) {
        case 0:
            CSToggled = !CSToggled
            desiredToggle = CSToggled
            desiredKey = .CS
        case 1:
            AItoggled = !AItoggled
            desiredToggle = AItoggled
            desiredKey = .AI
        case 2:
            renaissanceToggled = !renaissanceToggled
            desiredToggle = renaissanceToggled
            desiredKey = .Renaissance
        default:
            CSToggled = !CSToggled
            desiredToggle = CSToggled
            desiredKey = .CS
        }
        print(desiredToggle)
        settings[desiredKey.rawValue] = desiredToggle
        defaults.setBool(desiredToggle, forKey: desiredKey.rawValue)
    }
}
