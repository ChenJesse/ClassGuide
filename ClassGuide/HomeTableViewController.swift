//
//  HomeTableViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/22/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController {
    
    var courses: [Course] = []
    var savedCourses: [NSManagedObject]!
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    
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
        tableView.backgroundColor = .blackColor()
        tableView.registerNib(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        addRevealVCButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courses.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell", forIndexPath: indexPath) as! HomeTableViewCell
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
