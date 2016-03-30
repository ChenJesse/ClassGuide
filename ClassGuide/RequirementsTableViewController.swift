//
//  RequirementsTableViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/29/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

class RequirementsTableViewController: UITableViewController {
    var requirements: [Requirement]!
    var majorReqs: CSRequirements!
    var AIVector: AI!
    var renaissanceVector: Renaissance!
    var takenCourses: NSMutableSet!
    var plannedCourses: NSMutableSet!
    var progress: [[(String, Float)]] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "RequirementsTableViewCell", bundle: nil), forCellReuseIdentifier: "RequirementCell")
        tableView.backgroundColor = .blackColor()
        tableView.allowsSelection = false;
        addRevealVCButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        majorReqs.calculateProgress(takenCourses, plannedCourses: plannedCourses)
        AIVector.calculateProgress(takenCourses, plannedCourses: plannedCourses)
        renaissanceVector.calculateProgress(takenCourses, plannedCourses: plannedCourses)
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
        cell.progressBar.progress = desiredTuple.1
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        switch (section) {
        case 0:
            title = "Major Requirements"
        case 1:
            title = "Artificial Intelligence Vector"
        case 2:
            title = "Renaissance Vector"
        default:
            title = ""
        }
        return title
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(70)
    }
 
    func fetchProgress() {
        print("fetching progress")
        progress = []
        progress.append(majorReqs.printProgress())
        progress.append(AIVector.printProgress())
        progress.append(renaissanceVector.printProgress())
    }
}
