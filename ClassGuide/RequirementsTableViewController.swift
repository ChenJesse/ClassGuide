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
    var majorReqs: CSRequirements!
    var AIVector: AI!
    var renaissanceVector: Renaissance!
    
    var takenCourses: NSMutableSet!
    var plannedCourses: NSMutableSet!
    
    var requirements: [Requirement] = []
    var progress: [[(String, Float)]] = []
    var settings: [String: Bool]!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "RequirementsTableViewCell", bundle: nil), forCellReuseIdentifier: "RequirementCell")
        tableView.backgroundColor = .blackColor()
        navigationItem.title = "Progress"
        tableView.allowsSelection = false;
        addRevealVCButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        if settings[SettingsKey.CS.rawValue]! {
            majorReqs.calculateProgress(takenCourses, plannedCourses: plannedCourses)
        }
        if settings[SettingsKey.AI.rawValue]! {
            AIVector.calculateProgress(takenCourses, plannedCourses: plannedCourses)
        }
        if settings[SettingsKey.Renaissance.rawValue]! {
            renaissanceVector.calculateProgress(takenCourses, plannedCourses: plannedCourses)
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
        if (desiredTuple.1 == -1.0) { //course not suppported by app
            cell.percentLabel.text = "???.?%"
            cell.progressBar.progress = 1
            cell.progressBar.progressTintColor = .grayColor()
            cell.statusImageView.image = UIImage(named: "taskIncompleteIcon")
        } else {
            cell.percentLabel.text = "\(desiredTuple.1 * 100)%"
            cell.progressBar.progress = desiredTuple.1
            cell.progressBar.progressTintColor = UIColor.darkGreen
            let image = (desiredTuple.1 == 1.0) ? UIImage(named: "taskCompleteIcon") : UIImage(named: "taskIncompleteIcon")
            cell.statusImageView.image = image
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return requirements[section].title
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = .blackColor()
        header.alpha = 1.0 //make the header transparent
        header.textLabel!.textColor = .whiteColor()
        header.textLabel!.font = .systemFontOfSize(17)
    }
 
    func fetchProgress() {
        print("fetching progress")
        requirements = []
        progress = []
        if settings[SettingsKey.CS.rawValue]! {
            requirements.append(majorReqs)
            progress.append(majorReqs.printProgress())
        }
        if settings[SettingsKey.AI.rawValue]! {
            requirements.append(AIVector)
            progress.append(AIVector.printProgress())
        }
        if settings[SettingsKey.Renaissance.rawValue]! {
            requirements.append(renaissanceVector)
            progress.append(renaissanceVector.printProgress())
        }
    }
}
