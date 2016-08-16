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
    var wrappers: [ReqWrapper]!
    
    var takenCourses: NSMutableSet!
    var plannedCourses: NSMutableSet!
    
    var requirements: [ReqSet] = []
    var progress: [[RequirementItem]] = []
    var settings: [String: Bool]!
    var defaults: NSUserDefaults!
    var mandatoryOnly = false
    
    var cellTapped: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "RequirementsTableViewCell", bundle: nil), forCellReuseIdentifier: "RequirementCell")
        tableView.backgroundColor  = UIColor.lightGrey
        mandatoryOnly = defaults.boolForKey("mandatory")
        setupMandatoryToggle()
        setupSettingsButton()
        addRevealVCButton()
        populateCellTapped()
    }
    
    override func viewDidAppear(animated: Bool) {
        calculateAndFetchProgress()
        //navigationController?.hidesBarsOnSwipe = true
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
        var courseNumbers = ""
        desiredItem.courses.forEach { (course: Course) in
            courseNumbers += "\(course.courseNumber), "
        }
        cell.courseLabel.text = courseNumbers.chopSuffix(2)
        cell.optionalImageView.image = (desiredItem.priority == .Mandatory) ? UIImage(named: "mandatoryIcon") : UIImage(named: "optionalIcon")
        if (desiredItem.supported == .Unsupported) {
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return requirementsCellHeight
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if cellTapped[section] {
            return settingsCellHeight + 100
        }
        return settingsCellHeight
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = NSBundle.mainBundle().loadNibNamed("SettingsTableViewCell", owner: self, options: nil)[0] as! SettingsTableViewCell
        let containerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, settingsCellHeight + 100))
        cell.settingLabel.text = requirements[section].title
        cell.descriptionLabel.text = SettingsKey.getDescription(requirements[section].key)
        cell.toggleSwitch.hidden = true
        cell.section = section
        
        if cellTapped[section] { cell.rotateArrow() }
        
        cell.backgroundColor = UIColor.cornellRed.colorWithAlphaComponent(0.90)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RequirementsTableViewController.headerClicked(_:)))
        cell.addGestureRecognizer(tapGestureRecognizer)
        
        cell.frame = containerView.frame
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        cell.container = containerView
        containerView.addSubview(cell)
        containerView.clipsToBounds = true
        return containerView
    }
    
    func headerClicked(tap: UITapGestureRecognizer) {
        let header = tap.view as! SettingsTableViewCell
        
        cellTapped[header.section!] = !cellTapped[header.section!]
        tableView.beginUpdates()
        CATransaction.setCompletionBlock {
            self.tableView.reloadData()
        }
        tableView.endUpdates()
    }
 
    func calculateAndFetchProgress() {
        for wrapper in wrappers {
            if settings[wrapper.key.rawValue]! {
                wrapper.req.calculateProgress(takenCourses, plannedCourses: plannedCourses)
            }
        }
        requirements.removeAll()
        progress.removeAll()
        for wrapper in wrappers {
            if settings[wrapper.key.rawValue]! {
                requirements.append(wrapper.req)
                if mandatoryOnly {
                    progress.append(wrapper.req.printMandatoryProgress())
                } else {
                    progress.append(wrapper.req.printAllProgress())
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
        mandatorySelector.backgroundColor = UIColor.cornellRed
        mandatorySelector.tintColor = UIColor.blackColor()
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
    
    func populateCellTapped() {
        for _ in 1...vectorNum {
            cellTapped.append(false)
        }
    }
    
//    override func prefersStatusBarHidden() -> Bool {
//        return (self.navigationController?.navigationBarHidden)!
//    }
}
