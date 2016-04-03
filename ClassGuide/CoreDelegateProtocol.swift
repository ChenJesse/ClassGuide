//
//  CoreDelegateProtocol.swift
//  ClassGuide
//
//  Created by Jesse Chen on 4/2/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataDelegate: class {
    var courseToNSManagedObject: [Course: NSManagedObject]! { get set }
    var takenCourses: NSMutableSet! { get set }
    var plannedCourses: NSMutableSet! { get set }
    var managedContext: NSManagedObjectContext! { get set }
    var courseEntities: [NSManagedObject]! { get set }
    func handleChangedCourse(course: Course, status: Status)
    func createCourseEntity(course: Course)
}

extension CoreDataDelegate {
    func handleChangedCourse(course: Course, status: Status) {
        if course.status == .PlanTo {
            plannedCourses.removeObject(course)
        } else if course.status == .Taken {
            takenCourses.removeObject(course)
        }
        course.status = status
        if course.status == .PlanTo {
            plannedCourses.addObject(course)
        } else if course.status == .Taken {
            takenCourses.addObject(course)
        }
        managedContext.deleteObject(courseToNSManagedObject[course]!) //delete the old entity
        createCourseEntity(course)
    }
    
    func createCourseEntity(course: Course) {
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
        courseEntity.setValue(course.instructors, forKey: "instructors")
        courseEntities.append(courseEntity)
        courseToNSManagedObject[course] = courseEntity
    }
}