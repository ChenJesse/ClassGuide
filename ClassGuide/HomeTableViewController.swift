//
//  HomeTableViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/22/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController, CoreDataDelegate, CourseSearchDelegate {
    
    var courses: [Course] = []
    var courseToNSManagedObject: [Course: NSManagedObject]! = [:]
    
    var desiredCourses: [Course] = []
    
    var initialLoad = true
    var courseEntities: [NSManagedObject]!
    var takenCourses: NSMutableSet!
    var plannedCourses: NSMutableSet!
    var managedContext: NSManagedObjectContext!
    var seasonToggle: UIButton?
    var searchBar: UISearchBar!
    var searchQuery = ""
    var yearIndex = 2
    var season: Season = .Fall
    
    var controller: UITableViewController!
    var defaults: NSUserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller = self
        if (initialLoad) {
            handleInitialLoad()
        }
        processCourses()
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        addPanGesture()
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
        return desiredCourses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell", forIndexPath: indexPath) as! CourseTableViewCell
        let thisCourse = desiredCourses[indexPath.row]
        cell.courseCodeLabel.text = thisCourse.subject.rawValue + "\(thisCourse.courseNumber)"
        cell.courseTitleLabel.text = thisCourse.titleShort
        cell.courseTitleLabel.adjustsFontSizeToFitWidth = true
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
    
    func handleInitialLoad() {
        initialLoad = false
        takenCourses = NSMutableSet()
        plannedCourses = NSMutableSet()
        let dataManager = DataManager.init()
        dataManager.defaults = defaults
        fetchCoreData()
        dataManager.fetchCourses() { () in
            self.courses = dataManager.courseArray
            self.processTakenAndPlannedCourses()
            self.processCourses()
            self.saveCoreData()
            self.tableView.reloadData()
        }
        navigationItem.title = "CS Courses"
        tableView.backgroundColor = .blackColor()
        tableView.registerNib(UINib(nibName: "CourseTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        addRevealVCButton()
        setupSegmentedControl()
        setupSeasonToggle()
        setupSearchBar()
        processTakenAndPlannedCourses()
        processCourses()
        tableView.reloadData()
    }
    
    func fetchCoreData() {
        print("Attempting to fetch")
        let fetchRequest = NSFetchRequest(entityName: "Course")
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            if let courseEntities = results as? [NSManagedObject] {
                self.courseEntities = courseEntities.sort { ($0.valueForKey("courseNumber") as! Int) < ($1.valueForKey("courseNumber") as! Int)}
                for course in self.courseEntities {
                    let newCourse = Course(savedCourse: course)
                    courses.append(newCourse)
                    courseToNSManagedObject[newCourse] = course
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func saveCoreData() {
        print("Saving")
        if courseEntities.count == 0 {
            for course in courses {
                createCourseEntity(course)
            }
        }
        save()
    }
    
    func processTakenAndPlannedCourses() {
        for course in courses {
            if course.status == .Taken {
                takenCourses.addObject(course)
            } else if course.status == .PlanTo {
                plannedCourses.addObject(course)
            }
        }
    }

    func processCourses() {
        var semester: Semester!
        switch (yearIndex) {
        case 0:
            semester = (season == .Fall) ? .FA14 : .SP14
        case 1:
            semester = (season == .Fall) ? .FA15 : .SP15
        case 2:
            semester = (season == .Fall) ? .FA16 : .SP16
        default:
            semester = .FA16
        }
        desiredCourses = courses.filter({ (c) -> Bool in
            return c.semester == semester
        })
        filterCourses()
    }
    
    func setupSegmentedControl() {
        let yearSelector = UISegmentedControl(frame: CGRectMake(20, 20, 150, 30))
        yearSelector.addTarget(self, action: #selector(HomeTableViewController.switchSemester), forControlEvents: UIControlEvents.ValueChanged)
        yearSelector.backgroundColor = .blackColor()
        yearSelector.tintColor = UIColor.cornellRed
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        yearSelector.setTitleTextAttributes(attributes, forState: .Normal)
        yearSelector.insertSegmentWithTitle("'14", atIndex: 0, animated: true)
        yearSelector.insertSegmentWithTitle("'15", atIndex: 1, animated: true)
        yearSelector.insertSegmentWithTitle("'16", atIndex: 2, animated: true)
        yearSelector.selectedSegmentIndex = yearSelector.numberOfSegments - 1
        navigationItem.titleView = yearSelector
    }
    
    func setupSeasonToggle() {
        seasonToggle = UIButton(frame: CGRectMake(20, 20, 30, 30))
        seasonToggle?.addTarget(self, action: #selector(HomeTableViewController.toggleSeason(_:)), forControlEvents: .TouchUpInside)
        seasonToggle!.setImage(UIImage(named: "fallIcon"), forState: .Normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: seasonToggle!)
    }
    
    func toggleSeason(sender: UIButton) {
        let iconName = (season == .Fall) ? "springIcon" : "fallIcon"
        season = (season == .Fall) ? .Spring : .Fall
        seasonToggle!.setImage(UIImage(named: iconName), forState: .Normal)
        processCourses()
        tableView.reloadData()
    }
    
    func switchSemester(sender: UISegmentedControl) {
        yearIndex = sender.selectedSegmentIndex
        processCourses()
        tableView.reloadData()
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

}
