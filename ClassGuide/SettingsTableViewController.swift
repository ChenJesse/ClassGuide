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

    var sidebarVC: SidebarTableViewController!
    var requirementsVC: RequirementsTableViewController!
    
    var wrappers: [ReqWrapper]!
    var settings: [String: Bool]!
    var defaults: NSUserDefaults!
    
    var cellTapped: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .blackColor()
        tableView.registerNib(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        navigationItem.title = "Settings"
        normalizeNavBar()
        addRevealVCButton()
        populateCellTapped()
        setupRequirementsButton()
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
        cell.settingLabel.text = wrappers[indexPath.row].req.title
        cell.settingLabel.adjustsFontSizeToFitWidth = true
        cell.toggleSwitch.on = wrappers[indexPath.row].toggled
        cell.descriptionLabel.text = SettingsKey.getDescription(wrappers[indexPath.row].key)
        cell.descriptionLabel.hidden = !cellTapped[indexPath.row]
        cell.descriptionLabel.adjustsFontSizeToFitWidth = true
        cell.selectionStyle = .None
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if cellTapped[indexPath.row] {
            return settingsCellHeight + 100
        }
        return settingsCellHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        cellTapped[indexPath.row] = !cellTapped[indexPath.row]
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SettingsTableViewCell
        
        if !cellTapped[indexPath.row] {
            cell.descriptionLabel.hidden = !(self.cellTapped[indexPath.row])
        }
        cell.rotateArrow()
        
        tableView.beginUpdates()
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        CATransaction.setCompletionBlock {
            if self.cellTapped[indexPath.row] {
                cell.descriptionLabel.hidden = !(self.cellTapped[indexPath.row])
            }
        }
        tableView.endUpdates()
    }
    
    func handleToggle(cell: SettingsTableViewCell) {
        let indexPath = tableView.indexPathForCell(cell)
        let row = indexPath!.row
        let wrapper = wrappers[row]
        wrapper.toggled = !(wrapper.toggled)
        settings[wrapper.key.rawValue] = wrapper.toggled
        defaults.setBool(wrapper.toggled, forKey: wrapper.key.rawValue)
    }
    
    func populateCellTapped() {
        for _ in 1...vectorNum {
            cellTapped.append(false)
        }
    }
    
    func setupRequirementsButton() {
        let requirementsButton = UIButton(frame: CGRectMake(20, 20, 30, 30))
        let requirementsImage = UIImage(named: "majorsIcon")
        requirementsButton.setImage(requirementsImage, forState: .Normal)
        requirementsButton.addTarget(self, action: #selector(SettingsTableViewController.jumpToRequirements), forControlEvents: .TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: requirementsButton)
    }
    
    func jumpToRequirements() {
        sidebarVC.selectionHandler(requirementsVC)
    }
}
