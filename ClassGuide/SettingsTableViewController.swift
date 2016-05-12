//
//  SettingsTableViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/29/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

protocol SettingsDelegate {
    func handleToggle(cell: SettingsTableViewCell)
}

class SettingsTableViewController: UITableViewController, SettingsDelegate {

    var reqsAndTogglesAndKeys: [(Requirement, Bool, SettingsKey)]!
    var settings: [String: Bool]!
    var defaults: NSUserDefaults!
    let vectorNum = 10
    
    var cellTapped: [Bool] = []
    var tappedIndexPath: NSIndexPath?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.allowsSelection = false
        tableView.backgroundColor = .blackColor()
        tableView.registerNib(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        navigationItem.title = "Settings"
        addRevealVCButton()
        populateCellTapped()
    }
    
    override func viewDidAppear(animated: Bool) {
        addPanGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        cell.selectionStyle = .None
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if cellTapped[indexPath.row] {
            return settingsCellHeight + 50
        }
        return settingsCellHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tappedIndexPath = indexPath
        cellTapped[indexPath.row] = !cellTapped[indexPath.row]
        tableView.beginUpdates()
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        tableView.endUpdates()
    }
    
    func handleToggle(cell: SettingsTableViewCell) {
        let indexPath = tableView.indexPathForCell(cell)
        let row = indexPath!.row
        reqsAndTogglesAndKeys[row].1 = !(reqsAndTogglesAndKeys[row].1)
        settings[reqsAndTogglesAndKeys[row].2.rawValue] = reqsAndTogglesAndKeys[row].1
        defaults.setBool(reqsAndTogglesAndKeys[row].1, forKey: reqsAndTogglesAndKeys[row].2.rawValue)
    }
    
    func populateCellTapped() {
        for _ in 1...vectorNum {
            cellTapped.append(false)
        }
    }
}
