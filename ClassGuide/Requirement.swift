//
//  Requirement.swift
//  ClassGuide
//
//  Created by Jesse Chen on 4/2/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

protocol Requirement {
    var title: String { get }
    var requiredCourses: Int { get }
    var completed: Bool { get set }
    func calculateProgress(takenCourses: NSMutableSet, plannedCourses: NSMutableSet)
    func analyzeCourse(course: Course)
    func checkCompletion()
    func resetProgress()
    func printMandatoryProgress() -> [RequirementItem]
    func printOptionalProgress() -> [RequirementItem]
    
}

extension Requirement {
    func calculateProgress(takenCourses: NSMutableSet, plannedCourses: NSMutableSet) {
        resetProgress()
        var relevantCourses: [Course] = []
        relevantCourses.appendContentsOf(takenCourses.allObjects as! [Course])
        relevantCourses.appendContentsOf(plannedCourses.allObjects as! [Course])
        for course in relevantCourses {
            analyzeCourse(course)
        }
        checkCompletion()
    }
    
    func printAllProgress() -> [RequirementItem] {
        var progress: [RequirementItem] = []
        progress.appendContentsOf(printMandatoryProgress())
        progress.appendContentsOf(printOptionalProgress())
        
        return progress
    }
}