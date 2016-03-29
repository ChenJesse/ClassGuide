//
//  CSRequirements.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/24/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

//All the project courses that are not practicums (practicums are a subset)
public let introCourseNumbers: [Int] = [1110, 1112]
public let nonPracticumProjectsCourseNumbers: [Int] = [4758, 5150, 5152, 5412, 5414, 5431, 5625, 5643, 6670]
public let coreCourseNumbers: [Int] = [2800, 3110, 3410, 4410, 4820]

public enum Special: String {
    case Practicum =    "Practicum"
    case Project =      "Project"
    case Core =         "Core"
    case None =         "None"
}

public class CSRequirements: Requirement {
    
    //MARK: Requirement number that must be fulfilled in each category
    let requiredCourses = 11
    var completed = false
    public let introProgrammingRequirement = 2 // 111x and 2110/2112
    public let coreRequirement = 5 //2800, 3110, 3410, 4410, 4820
    public let electivesRequirement = 3 //electives 4000+
    
    //MARK: Requirements already fulfilled (or selected classes that plan to fulfill)
    public var taken111x = false
    public var taken2110or2112 = false
    public var taken2800 = false
    public var taken3110 = false
    public var taken3410 = false
    public var taken4410 = false
    public var taken4820 = false
    public var electivesFulfilled = 0
    public var projectFulfilled = false
    
    internal init (courses: [Course]) {
        for course in courses {
            analyzeCourse(course)
        }
    }
    
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
    
    func resetProgress() {
        taken111x = false
        taken2110or2112 = false
        taken2800 = false
        taken3110 = false
        taken3410 = false
        taken4410 = false
        taken4820 = false
        electivesFulfilled = 0
        projectFulfilled = false
    }
    
    func analyzeCourse(course: Course) {
        if checkPracticum(course) || checkProject(course) { projectFulfilled = true }
        else if getThousandsDigit(course) == 1 && getHundredthsDigit(course) == 1 && getTenthsDigit(course) == 1 {
            taken111x = true
        } else if course.courseNumber == 2110 || course.courseNumber == 2112 {
            taken2110or2112 = true
        }
        else if course.courseNumber == 2800 { taken2800 = true }
        else if course.courseNumber == 3110 { taken3110 = true }
        else if course.courseNumber == 3410 { taken3410 = true }
        else if course.courseNumber == 4410 { taken4410 = true }
        else if course.courseNumber == 4820 { taken4820 = true }
    }
    
    func checkCompletion() {
        completed = taken111x && taken2110or2112 && taken2800 && taken3110 && taken3410 && taken4410 && taken4820 && projectFulfilled && electivesFulfilled >= electivesRequirement
    }
    
    func printProgress() -> [(String, Float)] {
        var progress: [(String, Float)] = []
        progress.append(("Taken one CS111x course?", taken111x ? 1 : 0))
        progress.append(("Taken either CS2110 or CS2112?", taken2110or2112 ? 1 : 0))
        progress.append(("Taken CS2800?", taken2800 ? 1 : 0))
        progress.append(("Taken CS3110?", taken3110 ? 1 : 0))
        progress.append(("Taken CS3410?", taken3410 ? 1 : 0))
        progress.append(("Taken CS4410?", taken4410 ? 1 : 0))
        progress.append(("Taken CS4820?", taken4820 ? 1 : 0))
        progress.append(("Taken 3 CS4000+ courses?", Float(electivesFulfilled) / Float(electivesRequirement)))
        return progress
    }
}