//
//  SidebarTableViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/24/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

class SidebarTableViewController: UITableViewController {
    
    var homeVC: HomeTableViewController!
    var manageVC: ManageTableViewController!
    var requirementsVC: RequirementsTableViewController!
    var revealVC: SWRevealViewController!
    var settingsVC: SettingsTableViewController!
    var infoVC: SymbolViewController!
    var navController: UINavigationController!
    var settings: [String: Bool]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let inset = UIEdgeInsetsMake(64, 0, 0, 0)
        tableView.contentInset = inset
        tableView.delegate = self
        tableView.backgroundColor = .blackColor()
        tableView.separatorStyle = .SingleLine
        tableView.separatorColor = UIColor.darkGrey
        tableView.tableFooterView = UIView()
        tableView.registerNib(UINib(nibName: "SidebarTableViewCell", bundle: nil), forCellReuseIdentifier: "sidebarCell")
    }
    
    override func viewDidAppear(animated: Bool) {
        normalizeNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabNumber
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
        case 3:
            cell.iconImageView.image = UIImage(named: "settingsIcon")
            cell.categoryLabel.text = "Vector Settings"
        case 4:
            cell.iconImageView.image = UIImage(named: "informationIcon")
            cell.categoryLabel.text = "App Guide"
        default:
            break;
        }
        cell.backgroundColor = .blackColor()
        cell.selectionStyle = .None
        
        return cell
    }
 
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return sidebarCellHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let desiredVC: UIViewController
        switch (indexPath.row) {
        case 0:
            desiredVC = homeVC
        case 1:
            desiredVC = manageVC
        case 2:
            desiredVC = requirementsVC
        case 3:
            desiredVC = settingsVC
        case 4:
            desiredVC = infoVC
        default:
            desiredVC = homeVC
        }
        selectionHandler(desiredVC)
    }
    
    func selectionHandler(desiredVC: UIViewController) {
        switch (desiredVC) {
        case homeVC:
            break
        case manageVC:
            manageVC.takenCourses = homeVC.takenCourses
            manageVC.plannedCourses = homeVC.plannedCourses
            manageVC.courseEntities = homeVC.courseEntities
            manageVC.courseToNSManagedObject = homeVC.courseToNSManagedObject
        case requirementsVC:
            requirementsVC.plannedCourses = homeVC.plannedCourses
            requirementsVC.takenCourses = homeVC.takenCourses
            requirementsVC.settings = settingsVC.settings
        case settingsVC:
            break
        case infoVC:
            break
        default:
            break;
        }
        if let front = self.revealVC.frontViewController {
            if desiredVC == front {
                self.revealVC.setFrontViewPosition(.Left, animated: true)
                return
            }
        }
        navController.setViewControllers([desiredVC], animated: false)
        revealVC.setFrontViewPosition(.Left, animated: true)
    }
    
}
