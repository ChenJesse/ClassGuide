//
//  DetailViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/25/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var course: Course!
    var delegate: CoreDataDelegate!

    @IBOutlet weak var courseStatusSelector: UISegmentedControl!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseSubjectNumber: UILabel!
    @IBOutlet weak var fullTitle: UILabel!
    @IBOutlet weak var professors: UILabel!
    @IBOutlet weak var distribution: UILabel!
    @IBOutlet weak var special: UILabel!
    @IBOutlet weak var consent: UILabel!
    @IBOutlet weak var prerequisites: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var semester: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    internal func setup() {
        courseTitle.text = course.titleShort
        courseSubjectNumber.text = "\(course.subject)\(course.courseNumber)"
        fullTitle.text = "Full title: \(course.titleLong)"
        semester.text = "Semester: \(course.semester.rawValue)"
        professors.text = "Instructors: \(course.instructors)"
        distribution.text = "Distribution requirement: \(course.distributionRequirement.rawValue)"
        special.text = "Special requirement: " + printSpecialAttributes(course).chopSuffix(2)
        consent.text = "Consent: \(course.consent.rawValue)"
        prerequisites.text = "Prerequisites: \(course.prerequisites)"
        descriptionView.text = "Description: \(course.description)"
        courseStatusSelector.selectedSegmentIndex = course.status.rawValue
        courseTitle.sizeToFit()
        courseSubjectNumber.sizeToFit()
        fullTitle.sizeToFit()
    }
    
    @IBAction func statusChanged(sender: UISegmentedControl) {
        delegate.handleChangedCourse(course, status: Status(rawValue: sender.selectedSegmentIndex)!)
    }
}
