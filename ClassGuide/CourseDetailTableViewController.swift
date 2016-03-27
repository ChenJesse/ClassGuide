//
//  CourseDetailTableViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/24/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

class CourseDetailTableViewController: UITableViewController {
    
    var course: Course!
    let infoCount: Int = 11 //number of pieces of information per course to display
    let rowHeight = CGFloat(40)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.backgroundColor = .blackColor()
        tableView.separatorStyle = .None
        tableView.allowsSelection = false
        tableView.registerNib(UINib(nibName: "CourseDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "detailCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return infoCount
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionText: String
        switch (section) {
        case 0:
            sectionText = "Subject"
        case 1:
            sectionText = "Course Number"
        case 2:
            sectionText = "Distribution Requirement"
        case 3:
            sectionText = "Consent"
        case 4:
            sectionText = "Short Title"
        case 5:
            sectionText = "Full Title"
        case 6:
            sectionText = "Course ID"
        case 7:
            sectionText = "Dsecription"
        case 8:
            sectionText = "Prerequisites"
        case 9:
            sectionText = "Special"
        case 10:
            sectionText = "Status"
        default:
            sectionText = ""
        }
        
        return sectionText
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as! CourseDetailTableViewCell
        let infoText: String
        switch (indexPath.section) {
        case 0:
            infoText = course.subject.rawValue
        case 1:
            infoText = "\(course.courseNumber)"
        case 2:
            infoText = course.distributionRequirement.rawValue
        case 3:
            infoText = course.consent.rawValue
        case 4:
            infoText = course.titleShort
        case 5:
            infoText = course.titleLong
        case 6:
            infoText = "\(course.courseID)"
        case 7:
            infoText = course.description
            cell.infoLabel.sizeToFit()
        case 8:
            infoText = course.prerequisites
            cell.infoLabel.sizeToFit()
        case 9:
            infoText = printSpecialAttributes(course)
        case 10:
            infoText = "\(course.status)"
        default:
            infoText = ""
        }
        cell.infoLabel.text = infoText
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = (indexPath.section == 7 || indexPath.row == 8) ? rowHeight * 3 : rowHeight
        return height
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = .blackColor()
        header.alpha = 1.0 //make the header transparent
        header.textLabel!.textColor = .whiteColor()
        header.textLabel!.font = .systemFontOfSize(15, weight: UIFontWeightThin)
    }    
}
