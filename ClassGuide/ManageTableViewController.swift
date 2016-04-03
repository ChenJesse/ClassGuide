//
//  ManageTableViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/25/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit
import CoreData

class ManageTableViewController: UITableViewController, CoreDataDelegate {
    
    var relevantCourses: [Course] = []
    var takenCourses: NSMutableSet!
    var plannedCourses: NSMutableSet!
    var courseEntities: [NSManagedObject]!
    var managedContext: NSManagedObjectContext!
    var courseToNSManagedObject: [Course: NSManagedObject]!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "CourseTableViewCell", bundle: nil), forCellReuseIdentifier: "CourseCell")
        tableView.backgroundColor = .blackColor()
        navigationItem.title = "Manage"
        relevantCourses.appendContentsOf(takenCourses.allObjects as! [Course])
        relevantCourses.appendContentsOf(plannedCourses.allObjects as! [Course])
        addRevealVCButton()
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        relevantCourses.removeAll()
        relevantCourses.appendContentsOf(takenCourses.allObjects as! [Course])
        relevantCourses.appendContentsOf(plannedCourses.allObjects as! [Course])
        relevantCourses = relevantCourses.sort { $0.courseNumber < $1.courseNumber }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relevantCourses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseCell", forIndexPath: indexPath) as! CourseTableViewCell
        let thisCourse = relevantCourses[indexPath.row]
        cell.courseCodeLabel.text = thisCourse.subject.rawValue + "\(thisCourse.courseNumber)"
        cell.courseCodeLabel.sizeToFit()
        cell.courseTitleLabel.text = thisCourse.titleShort
        var image: UIImage?
        switch (thisCourse.status) {
        case .None:
            image = UIImage(named: "questionmarkIcon")!
        case .PlanTo:
            image = UIImage(named: "planIcon")
        case .Taken:
            image = UIImage(named: "checkIcon")
        }
        cell.statusImageView.image = image!
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = DetailViewController()
        detailVC.course = relevantCourses[indexPath.row]
        detailVC.delegate = self
        let backButton = UIBarButtonItem(title: "Courses", style: .Plain, target: nil, action: nil)
        backButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Normal)
        navigationItem.backBarButtonItem = backButton
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.cornellRed
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return courseCellHeight
    }
    
    func saveCoreData() {
        print("Attempting to save")
        //save
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
