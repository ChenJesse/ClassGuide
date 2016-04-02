//
//  RequirementsTableViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/29/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

class RequirementsTableViewController: UITableViewController {
    //MARK: All the Requirement objects individually

    var reqsAndTogglesAndKeys: [(Requirement, Bool, SettingsKey)]!
    
    var takenCourses: NSMutableSet!
    var plannedCourses: NSMutableSet!
    
    var requirements: [Requirement] = []
    var progress: [[(String, Float)]] = []
    var settings: [String: Bool]!
    var defaults: NSUserDefaults!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "RequirementsTableViewCell", bundle: nil), forCellReuseIdentifier: "RequirementCell")
        tableView.backgroundColor = .blackColor()
        navigationItem.title = "Progress"
        //tableView.allowsSelection = false;
        addRevealVCButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        for tuple in reqsAndTogglesAndKeys {
            if settings[tuple.2.rawValue]! {
                tuple.0.calculateProgress(takenCourses, plannedCourses: plannedCourses)
            }
        }
        fetchProgress()
        tableView.reloadData()
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
        let desiredTuple = progress[indexPath.section][indexPath.row]
        cell.requirementLabel.text = desiredTuple.0
        cell.requirementLabel.adjustsFontSizeToFitWidth = true
        if (desiredTuple.1 == unsupportedCourseValue) { //course not suppported by app
            cell.isCSCourse = false
            cell.statusImageView.image = UIImage(named: "handIcon")
            let courseCompleted = defaults.boolForKey(desiredTuple.0)
            if courseCompleted {
                setCellAsCompleted(cell)
            } else {
                setCellAsIncomplete(cell)
            }
        } else {
            cell.percentLabel.text = "\(Int(desiredTuple.1 * 100))%"
            let ceilingedProgress = (desiredTuple.1 > 1) ? 1 : desiredTuple.1
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
 
    func fetchProgress() {
        print("fetching progress")
        requirements = []
        progress = []
        for tuple in reqsAndTogglesAndKeys {
            if settings[tuple.2.rawValue]! {
                requirements.append(tuple.0)
                progress.append(tuple.0.printProgress())
            }
        }
    }
    
    func setCellAsCompleted(cell: RequirementsTableViewCell) {
        cell.percentLabel.text = "100%"
        cell.progressCircle.angle = 360
    }
    
    func setCellAsIncomplete(cell: RequirementsTableViewCell) {
        cell.percentLabel.text = "???%"
        cell.progressCircle.angle = 0
    }
    
    func setCellAsCompletedAnimated(cell: RequirementsTableViewCell) {
        cell.percentLabel.text = "100%"
        cell.progressCircle.animateToAngle(360, duration: 0.5, completion: nil)
    }
    
    func setCellAsIncompleteAnimated(cell: RequirementsTableViewCell) {
        cell.percentLabel.text = "???%"
        cell.progressCircle.animateFromAngle(360, toAngle: 0, duration: 0.5, completion: nil)
    }
}
