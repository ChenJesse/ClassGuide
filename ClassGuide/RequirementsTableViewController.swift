//
//  RequirementsTableViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/29/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

class RequirementsTableViewController: UITableViewController {
    
    var sidebarVC: SidebarTableViewController!
    var settingsVC: SettingsTableViewController!
    var reqsAndTogglesAndKeys: [(Requirement, Bool, SettingsKey)]!
    
    var takenCourses: NSMutableSet!
    var plannedCourses: NSMutableSet!
    
    var requirements: [Requirement] = []
    var progress: [[RequirementItem]] = []
    var settings: [String: Bool]!
    var defaults: NSUserDefaults!
    var mandatoryOnly = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "RequirementsTableViewCell", bundle: nil), forCellReuseIdentifier: "RequirementCell")
        tableView.backgroundColor = .blackColor()
        mandatoryOnly = defaults.boolForKey("mandatory")
        setupMandatoryToggle()
        setupSettingsButton()
        addRevealVCButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        calculateAndFetchProgress()
        tableView.reloadData()
        addPanGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return progress.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return progress[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RequirementCell", forIndexPath: indexPath) as! RequirementsTableViewCell
        let desiredItem = progress[indexPath.section][indexPath.row]
        cell.requirementLabel.text = desiredItem.description
        cell.requirementLabel.adjustsFontSizeToFitWidth = true
        cell.optionalImageView.image = (desiredItem.priority == .Mandatory) ? UIImage(named: "mandatoryIcon") : UIImage(named: "optionalIcon")
        if (desiredItem.percentage == unsupportedCourseValue) { //course not suppported by app
            cell.isCSCourse = false
            cell.statusImageView.image = UIImage(named: "handIcon")
            let courseCompleted = defaults.boolForKey(desiredItem.description)
            if courseCompleted {
                setCellAsCompleted(cell)
            } else {
                setCellAsIncomplete(cell)
            }
            
        } else {
            cell.percentLabel.text = "\(Int(desiredItem.percentage * 100))%"
            let ceilingedProgress = (desiredItem.percentage > 1) ? 1 : desiredItem.percentage
            cell.progressCircle.angle = Int(ceilingedProgress * 360)
            cell.statusImageView.image = UIImage(named: "noHandIcon")
            cell.isCSCourse = true
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! RequirementsTableViewCell
        if !cell.isCSCourse {
            let courseCompleted = !(defaults.boolForKey(cell.requirementLabel.text!))
            defaults.setBool(courseCompleted, forKey: cell.requirementLabel.text!)
            if courseCompleted {
                setCellAsCompletedAnimated(cell)
            } else {
                setCellAsIncompleteAnimated(cell)
            }
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return requirements[section].title
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return requirementsCellHeight
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = .blackColor()
        header.alpha = 1.0 //make the header transparent
        header.textLabel!.textColor = .whiteColor()
        header.textLabel!.font = .systemFontOfSize(17)
        header.textLabel?.textAlignment = .Center
    }
 
    func calculateAndFetchProgress() {
        print("fetching progress")
        for tuple in reqsAndTogglesAndKeys {
            if settings[tuple.2.rawValue]! {
                tuple.0.calculateProgress(takenCourses, plannedCourses: plannedCourses)
            }
        }
        requirements.removeAll()
        progress.removeAll()
        for tuple in reqsAndTogglesAndKeys {
            if settings[tuple.2.rawValue]! {
                requirements.append(tuple.0)
                if mandatoryOnly {
                    progress.append(tuple.0.printMandatoryProgress())
                } else {
                    progress.append(tuple.0.printAllProgress())
                }
            }
        }
    }
    
    func setCellAsCompleted(cell: RequirementsTableViewCell) {
        cell.percentLabel.text = "100%"
        cell.progressCircle.angle = 360
    }
    
    func setCellAsIncomplete(cell: RequirementsTableViewCell) {
        cell.percentLabel.text = "?%"
        cell.progressCircle.angle = 0
    }
    
    func setCellAsCompletedAnimated(cell: RequirementsTableViewCell) {
        cell.percentLabel.text = "100%"
        cell.progressCircle.animateToAngle(360, duration: 0.5, completion: nil)
    }
    
    func setCellAsIncompleteAnimated(cell: RequirementsTableViewCell) {
        cell.percentLabel.text = "?%"
        cell.progressCircle.animateFromAngle(360, toAngle: 0, duration: 0.5, completion: nil)
    }
    
    func setupMandatoryToggle() {
        let mandatorySelector = UISegmentedControl(frame: CGRectMake(20, 20, 100, 30))
        mandatorySelector.backgroundColor = .blackColor()
        mandatorySelector.tintColor = UIColor.cornellRed
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        mandatorySelector.setTitleTextAttributes(attributes, forState: .Normal)
        mandatorySelector.insertSegmentWithTitle("All", atIndex: 0, animated: true)
        mandatorySelector.insertSegmentWithTitle("M", atIndex: 1, animated: true)
        mandatorySelector.addTarget(self, action: #selector(RequirementsTableViewController.switchMandatory), forControlEvents: UIControlEvents.ValueChanged)
        mandatorySelector.selectedSegmentIndex = (defaults.boolForKey("mandatory")) ? 1 : 0
        navigationItem.titleView = mandatorySelector
    }
    
    func setupSettingsButton() {
        let settingsButton = UIButton(frame: CGRectMake(20, 20, 30, 30))
        let settingsImage = UIImage(named: "settingsIcon")
        settingsButton.setImage(settingsImage, forState: .Normal)
        settingsButton.addTarget(self, action: #selector(RequirementsTableViewController.jumpToSettings), forControlEvents: .TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
    }
    
    func switchMandatory(sender: UISegmentedControl) {
        mandatoryOnly = (sender.selectedSegmentIndex == 0) ? false : true
        defaults.setBool(mandatoryOnly, forKey: "mandatory")
        calculateAndFetchProgress()
        tableView.reloadData()
    }
    
    func jumpToSettings() {
        sidebarVC.selectionHandler(settingsVC)
    }
}
