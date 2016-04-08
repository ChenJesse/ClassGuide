//
//  ManageTableViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/25/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit
import CoreData

class ManageTableViewController: UITableViewController, CoreDataDelegate, CourseSearchDelegate {
    
    var controller: UITableViewController!
    var searchBar: UISearchBar!
    var searchQuery = ""
    
    var desiredCourses: [Course] = []
    var relevantCourses: [Course] = []
    var takenCourses: NSMutableSet!
    var plannedCourses: NSMutableSet!
    var courseEntities: [NSManagedObject]!
    var managedContext: NSManagedObjectContext!
    var courseToNSManagedObject: [Course: NSManagedObject]!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        controller = self
        tableView.registerNib(UINib(nibName: "CourseTableViewCell", bundle: nil), forCellReuseIdentifier: "CourseCell")
        tableView.backgroundColor = .blackColor()
        navigationItem.title = "Manage"
        self.editButtonItem().tintColor = .whiteColor()
        navigationItem.rightBarButtonItem = self.editButtonItem()
        refreshCourses()
        addRevealVCButton()
        setupSearchBar()
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        addPanGesture()
        refreshCourses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return desiredCourses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseCell", forIndexPath: indexPath) as! CourseTableViewCell
        let thisCourse = desiredCourses[indexPath.row]
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
        cell.backgroundColor = UIColor.cornellRed
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = DetailViewController()
        detailVC.course = desiredCourses[indexPath.row]
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
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            handleChangedCourse(desiredCourses[indexPath.row], status: .None)
            refreshCourses()
        }
    }
    
    func refreshCourses() {
        relevantCourses.removeAll()
        relevantCourses.appendContentsOf(takenCourses.allObjects as! [Course])
        relevantCourses.appendContentsOf(plannedCourses.allObjects as! [Course])
        relevantCourses = relevantCourses.sort { $0.courseNumber < $1.courseNumber }
        processCourses()
        tableView.reloadData()
    }
    
    func saveCoreData() {
        print("Attempting to save")
        save()
    }
    
    func processCourses() {
        desiredCourses = relevantCourses.map { $0 }
        filterCourses()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        handleSearchBar(searchBar, textDidChange: searchText)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        handleSearchBarTextDidBeginEditing(searchBar)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        handleSearchBarCancelButtonClicked(searchBar)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        handleSearchBarSearchButtonClicked(searchBar)
    }
}
