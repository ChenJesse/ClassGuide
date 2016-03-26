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
    
    var selectedSemesterCourses: [Course] = []
    var FA14courses: [Course] = []
    var SP14courses: [Course] = []
    var FA15courses: [Course] = []
    var SP15courses: [Course] = []
    var FA16courses: [Course] = []
    var SP16courses: [Course] = []
    
    var initialLoad = true
    var savedCourses: [NSManagedObject]!
    var takenCourses: [Course] = []
    var plannedCourses: [Course] = []
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    var seasonToggle: UIButton?
    var yearIndex = 2
    var season: Season = .Fall
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (initialLoad) {
            initialLoad = false
            appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            managedContext = appDelegate.managedObjectContext
            let dataManager = DataManager.init()
            fetchCoreData()
            if savedCourses.count == 0 {
                print("Have to fetch courses from API")
                dataManager.fetchCourses() { () in
                    self.courses = dataManager.courseArray
                    self.processCourses()
                    self.setCourseArray()
                    self.tableView.reloadData()
                }
            } else {
                print("Didn't have to fetch")
            }
            
            tableView.backgroundColor = .blackColor()
            tableView.registerNib(UINib(nibName: "CourseTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
            addRevealVCButton()
            setupSegmentedControl()
            setupSeasonToggle()
            processCourses()
        }
        setCourseArray()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSemesterCourses.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell", forIndexPath: indexPath) as! CourseTableViewCell
        let thisCourse = selectedSemesterCourses[indexPath.row]
        cell.courseCodeLabel.text = thisCourse.subject.rawValue + "\(thisCourse.courseNumber)"
        cell.courseCodeLabel.sizeToFit()
        cell.courseTitleLabel.text = thisCourse.titleShort
        var image: UIImage?
        switch (thisCourse.status) {
        case .None:
            image = UIImage(named: "questionmarkIcon")!
        case .PlanTo:
            break;
        default:
            image = UIImage(named: "questionmarkIcon")!
        }
        cell.statusImageView.image = image!
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let detailVC = CourseDetailTableViewController()
//        detailVC.course = selectedSemesterCourses[indexPath.row]
//        navigationController?.pushViewController(detailVC, animated: true)
        let detailVC = DetailViewController()
        detailVC.course = selectedSemesterCourses[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(60)
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
                courseEntity.setValue(course.semester.rawValue, forKey: "semester")
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
                courseEntity.setValue(course.instructors, forKey: "instructors")
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
        FA14courses = courses.filter({ (c) -> Bool in
            return c.semester == .FA14
        })
        SP14courses = courses.filter({ (c) -> Bool in
            return c.semester == .SP14
        })
        FA15courses = courses.filter({ (c) -> Bool in
            return c.semester == .FA15
        })
        SP15courses = courses.filter({ (c) -> Bool in
            return c.semester == .SP15
        })
        FA16courses = courses.filter({ (c) -> Bool in
            return c.semester == .FA16
        })
        SP16courses = courses.filter({ (c) -> Bool in
            return c.semester == .SP16
        })
    }
    
    func setupSegmentedControl() {
        let yearSelector = UISegmentedControl(frame: CGRectMake(20, 20, 150, 30))
        yearSelector.addTarget(self, action: #selector(CourseTableViewController.switchSemester), forControlEvents: UIControlEvents.ValueChanged)
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
        seasonToggle?.addTarget(self, action: #selector(CourseTableViewController.toggleSeason(_:)), forControlEvents: .TouchUpInside)
        seasonToggle!.setImage(UIImage(named: "fallIcon"), forState: .Normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: seasonToggle!)
    }
    
    func toggleSeason(sender: UIButton) {
        let iconName = (season == .Fall) ? "springIcon" : "fallIcon"
        season = (season == .Fall) ? .Spring : .Fall
        seasonToggle!.setImage(UIImage(named: iconName), forState: .Normal)
        setCourseArray()
        tableView.reloadData()
    }
    
    func switchSemester(sender: UISegmentedControl) {
        print("switching")
        yearIndex = sender.selectedSegmentIndex
        setCourseArray()
        print(yearIndex)
        tableView.reloadData()
    }
    
    func setCourseArray() {
        print("setting course")
        switch (yearIndex) {
        case 0:
            selectedSemesterCourses = (season == .Fall) ? FA14courses : SP14courses
        case 1:
            selectedSemesterCourses = (season == .Fall) ? FA15courses : SP15courses
        case 2:
            selectedSemesterCourses = (season == .Fall) ? FA16courses : SP16courses
        default:
            selectedSemesterCourses = FA16courses
        }
    }
}
