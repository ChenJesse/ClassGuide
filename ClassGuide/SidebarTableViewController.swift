//
//  SidebarTableViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/24/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

class SidebarTableViewController: UITableViewController {
    
    var homeVC: CourseTableViewController!
    var manageVC: ManageTableViewController!
    var revealVC: SWRevealViewController!
    var navController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.separatorStyle = .SingleLine
        tableView.backgroundColor = .blackColor()
        tableView.registerNib(UINib(nibName: "SidebarTableViewCell", bundle: nil), forCellReuseIdentifier: "sidebarCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sidebarCell", forIndexPath: indexPath) as! SidebarTableViewCell
        
        switch (indexPath.row) {
        case 0:
            cell.iconImageView.image = UIImage(named: "coursesIcon")
            cell.categoryLabel.text = "Courses"
        case 1:
            cell.iconImageView.image = UIImage(named: "manageIcon")
            cell.categoryLabel.text = "Manage"
        case 2:
            cell.iconImageView.image = UIImage(named: "majorsIcon")
            cell.categoryLabel.text = "Requirements"
        default:
            break;
        }
        
        return cell
    }
 
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(75)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let desiredVC: UIViewController
        switch (indexPath.row) {
        case 0:
            desiredVC = homeVC
        case 1:
            desiredVC = manageVC
            manageVC.takenCourses = homeVC.takenCourses
            manageVC.plannedCourses = homeVC.plannedCourses
            manageVC.savedCourses = homeVC.savedCourses
            manageVC.courseToNSManagedObject = homeVC.courseToNSManagedObject
        default:
            desiredVC = homeVC
        }
        selectionHandler(desiredVC)
    }
    
    func selectionHandler(desiredVC: UIViewController) {
        if let front = self.revealVC.frontViewController {
            if desiredVC == front {
                self.revealVC.setFrontViewPosition(.Left, animated: true)
                print("going into base case")
                return
            }
        }
        if desiredVC == manageVC { print("We have manageVC") }
        navController.setViewControllers([desiredVC], animated: false)
        revealVC.setFrontViewPosition(.Left, animated: true)
    }
    
}
