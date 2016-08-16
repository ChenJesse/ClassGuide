//
//  ReqSet.swift
//  ClassGuide
//
//  Created by Jesse Chen on 8/15/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

protocol ReqSet {
    static var sharedInstance: ReqSet { get }
    var title: String { get }
    var key: SettingsKey { get }
    var reqItems: [RequirementItem]! { get set }
    func analyzeCourse(course: Course)
    func resetProgress()
}

extension ReqSet {
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
    
    func printMandatoryProgress() -> [RequirementItem] {
        return reqItems.filter({ (item: RequirementItem) in return item.priority == .Mandatory })
    }
    
    func printOptionalProgress() -> [RequirementItem] {
        return reqItems.filter({ (item: RequirementItem) in return item.priority == .Optional })
    }
    
    func checkCompletion() -> Bool {
        let boolArray: [Bool] = reqItems.map( {(item: RequirementItem) in item.completed } )
        return !boolArray.contains(false)
    }
}