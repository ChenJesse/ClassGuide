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
    
    var CSToggled: Bool!
    var AItoggled: Bool!
    var renaissanceToggled: Bool!
    var CSEToggled: Bool!
    var graphicsToggled: Bool!
    var NSToggled: Bool!
    var PLToggled: Bool!
    var SEToggled: Bool!
    var SDToggled: Bool!
    var theoryToggled: Bool!
    
    var settings: [String: Bool]!
    var defaults: NSUserDefaults!
    
    let vectorNum = 10
        
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
        return vectorNum
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
        case 3:
            settingsDescription = "Computational Science and Engineering (Vector)"
            onOrOff = settings[SettingsKey.CSE.rawValue]!
        case 4:
            settingsDescription = "Graphics"
            onOrOff = settings[SettingsKey.Graphics.rawValue]!
        case 5:
            settingsDescription = "Network Science"
            onOrOff = settings[SettingsKey.NS.rawValue]!
        case 6:
            settingsDescription = "Programming Languages"
            onOrOff = settings[SettingsKey.PL.rawValue]!
        case 7:
            settingsDescription = "Software Engineering"
            onOrOff = settings[SettingsKey.SE.rawValue]!
        case 8:
            settingsDescription = "Systems / Databases"
            onOrOff = settings[SettingsKey.SD.rawValue]!
        case 9:
            settingsDescription = "Theory"
            onOrOff = settings[SettingsKey.Theory.rawValue]!
        default:
            settingsDescription = ""
            onOrOff = false
        }
        cell.settingLabel.text = settingsDescription
        cell.settingLabel.adjustsFontSizeToFitWidth = true
        cell.toggleSwitch.on = onOrOff
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(65)
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
        case 3:
            CSEToggled = !CSEToggled
            desiredToggle = CSEToggled
            desiredKey = .CSE
        case 4:
            graphicsToggled = !graphicsToggled
            desiredToggle = graphicsToggled
            desiredKey = .Graphics
        case 5:
            NSToggled = !NSToggled
            desiredToggle = NSToggled
            desiredKey = .NS
        case 6:
            PLToggled = !PLToggled
            desiredToggle = PLToggled
            desiredKey = .PL
        case 7:
            SEToggled = !SEToggled
            desiredToggle = SEToggled
            desiredKey = .SE
        case 8:
            SDToggled = !SDToggled
            desiredToggle = SDToggled
            desiredKey = .SD
        case 9:
            theoryToggled = !theoryToggled
            desiredToggle = theoryToggled
            desiredKey = .Theory
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
