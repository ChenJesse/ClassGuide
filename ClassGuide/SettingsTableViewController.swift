//
//  SettingsTableViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/29/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var CSReqsToggled = false
    var AItoggled = false
    var renaissanceToggled = false
    
    var CSReqs: CSRequirements!
    var AIVector: AI!
    var renaissanceVector: Renaissance!
    var requirements: [Requirement]!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        
        setupToggles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if CSReqsToggled { requirements.append(CSReqs) }
        if AItoggled { requirements.append(AIVector) }
        if renaissanceToggled { requirements.append(renaissanceVector) }
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
        
        let settingsDescription: String
        switch (indexPath.row) {
        case 0:
            settingsDescription = "CS Requirements"
        case 1:
            settingsDescription = "AI"
        case 2:
            settingsDescription = "Renaissance"
        default:
            settingsDescription = ""
        }
        cell.settingLabel.text = settingsDescription
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var desiredToggle: Bool
        var desiredReq: Requirement
        switch(indexPath.row) {
        case 0:
            desiredToggle = CSReqsToggled
            desiredReq = CSReqs
        case 1:
            desiredToggle = AItoggled
            desiredReq = AIVector
        case 2:
            desiredToggle = renaissanceToggled
            desiredReq = renaissanceVector
        default:
            desiredToggle = CSReqsToggled
            desiredReq = CSReqs
        }
        
        desiredToggle = !desiredToggle
        if (desiredToggle) {
            if !requirements.contains({ requirement in
                return requirement as? AnyObject === desiredReq as? AnyObject
            }) { requirements.append(desiredReq) }
        }
    }
    
    func setupToggles() {
        for req in requirements {
            switch (req) {
            case CSReqs:
                CSReqsToggled = true
            }
        }
    }
}
