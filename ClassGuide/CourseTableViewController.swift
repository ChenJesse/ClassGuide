//
//  CourseTableViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/22/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit
import CoreData

public enum Season {
    case Fall
    case Spring
}

class CourseTableViewController: UITableViewController {
    
    var courses: [Course] = []
    var savedCourses: [NSManagedObject]!
    var takenCourses: [Course] = []
    var plannedCourses: [Course] = []
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    var seasonToggle: UIButton?
    var season: Season = .Fall
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
        let dataManager = DataManager.init()
        fetchCoreData()
        if savedCourses.count == 0 {
            print("Have to fetch courses from API")
            dataManager.fetchCourses() { () in
                self.courses = dataManager.courseArray
                self.tableView.reloadData()
            }
        } else { print("Didn't have to fetch") }
        processCourses()
        tableView.backgroundColor = .blackColor()
        tableView.registerNib(UINib(nibName: "CourseTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        addRevealVCButton()
        setupSegmentedControl()
        setupSeasonToggle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell", forIndexPath: indexPath) as! CourseTableViewCell
        let thisCourse = courses[indexPath.row]
        cell.courseCodeLabel.text = thisCourse.subject.rawValue + "\(thisCourse.courseNumber)"
        cell.courseTitleLabel.text = thisCourse.titleShort
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = CourseDetailTableViewController()
        detailVC.course = courses[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func fetchCoreData() {
        print("Attempting to fetch")
        let fetchRequest = NSFetchRequest(entityName: "Course")
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            if let savedCourses = results as? [NSManagedObject] {
                self.savedCourses = savedCourses.sort { ($0.valueForKey("courseNumber") as! Int) < ($1.valueForKey("courseNumber") as! Int)}
                for course in self.savedCourses {
                    courses.append(Course(savedCourse: course))
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func saveCoreData() {
        print("Attempting to save")
        if savedCourses.count == 0 { //initial save preparation
            for course in courses {
                let entity = NSEntityDescription.entityForName("Course", inManagedObjectContext: managedContext)
                let courseEntity = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                courseEntity.setValue(course.subject.rawValue, forKey: "subject")
                courseEntity.setValue(course.courseNumber, forKey: "courseNumber")
                courseEntity.setValue(course.distributionRequirement.rawValue, forKey: "distributionRequirement")
                courseEntity.setValue(course.consent.rawValue, forKey: "consent")
                courseEntity.setValue(course.titleShort, forKey: "titleShort")
                courseEntity.setValue(course.titleLong, forKey: "titleLong")
                courseEntity.setValue(course.courseID, forKey: "courseID")
                courseEntity.setValue(course.description, forKey: "descr")
                courseEntity.setValue(course.prerequisites, forKey: "prerequisites")
                courseEntity.setValue(course.status.rawValue, forKey: "status")
                courseEntity.setValue(course.special.rawValue, forKey: "special")
                savedCourses.append(courseEntity)
                print("saving")
            }
        } else { //update the current objects
        }
        //save
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    func processCourses() {
        takenCourses = courses.filter({ (c) -> Bool in
            return c.status == .Taken
        })
        plannedCourses = courses.filter({ (c) -> Bool in
            return c.status == .PlanTo
        })
    }
    
    func setupSegmentedControl() {
        let yearSelector = UISegmentedControl(frame: CGRectMake(20, 20, 150, 30))
        yearSelector.backgroundColor = UIColor.cornellRed
        yearSelector.tintColor = .blackColor()
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        yearSelector.setTitleTextAttributes(attributes, forState: .Normal)
        yearSelector.insertSegmentWithTitle("14", atIndex: 0, animated: true)
        yearSelector.insertSegmentWithTitle("15", atIndex: 1, animated: true)
        yearSelector.insertSegmentWithTitle("16", atIndex: 2, animated: true)
        navigationItem.titleView = yearSelector
    }
    
    func setupSeasonToggle() {
        seasonToggle = UIButton(frame: CGRectMake(20, 20, 30, 30))
        seasonToggle?.addTarget(self, action: #selector(CourseTableViewController.toggleSeason(_:)), forControlEvents: .TouchUpInside)
        seasonToggle!.setImage(UIImage(named: "fallIcon"), forState: .Normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: seasonToggle!)
    }
    
    func toggleSeason(sender: UIButton) {
        let iconName = (season == .Fall) ? "springIcon" : "fallIcon"
        season = (season == .Fall) ? .Spring : .Fall
        seasonToggle!.setImage(UIImage(named: iconName), forState: .Normal)
    }
}
