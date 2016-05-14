//
//  CSRequirements.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/24/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

//All the project courses that are not practicums (practicums are a subset)

public class CSRequirements: Requirement {
    let title = "CS Major Requirements"
    let key = SettingsKey.CS
    //MARK: Requirement number that must be fulfilled in each category
    let requiredCourses = 11
    var completed = false
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
    var seenElectives: [Int] = []
    
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
        seenElectives = []
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
        else if checkFxxx(course) && !seenElectives.contains(course.courseNumber) {
            electivesFulfilled += 1
            seenElectives.append(course.courseNumber)
        }
    }
    
    func checkCompletion() {
        completed = taken111x && taken2110or2112 && taken2800 && taken3110 && taken3410 && taken4410 && taken4820 && projectFulfilled && electivesFulfilled >= electivesRequirement
    }
    
    func printOptionalProgress() -> [RequirementItem] {
        return []
    }
    
    func printMandatoryProgress() -> [RequirementItem] {
        var progress: [RequirementItem] = []
        progress.append(RequirementItem(description: "CS111x (Intro) ", percentage: taken111x ? 1 : 0, type: .Mandatory))
        progress.append(RequirementItem(description: "CS2110/CS2112 (Intro) ", percentage: taken2110or2112 ? 1 : 0, type: .Mandatory))
        progress.append(RequirementItem(description: "CS2800 (Core) ", percentage: taken2800 ? 1 : 0, type: .Mandatory))
        progress.append(RequirementItem(description: "CS3110 (Core) ", percentage: taken3110 ? 1 : 0, type: .Mandatory))
        progress.append(RequirementItem(description: "CS3410 (Core) ", percentage: taken3410 ? 1 : 0, type: .Mandatory))
        progress.append(RequirementItem(description: "CS4410 (Core) ", percentage: taken4410 ? 1 : 0, type: .Mandatory))
        progress.append(RequirementItem(description: "CS4820 (Core) ", percentage: taken4820 ? 1 : 0, type: .Mandatory))
        progress.append(RequirementItem(description: "Project Course (Core) ", percentage: projectFulfilled ? 1 : 0, type: .Mandatory))
        progress.append(RequirementItem(description: "3(CS4000+) (Electives) ", percentage: Float(electivesFulfilled) / Float(electivesRequirement), type: .Mandatory))
        progress.append(RequirementItem(description: "Calculus Sequence ", percentage: unsupportedCourseValue, type: .Mandatory))
        progress.append(RequirementItem(description: "Probability Course ", percentage: unsupportedCourseValue, type: .Mandatory))
        progress.append(RequirementItem(description: "3(Technical Electives, 3000+) ", percentage: unsupportedCourseValue, type: .Mandatory))
        progress.append(RequirementItem(description: "3(External Specialization, 3000+) ", percentage: unsupportedCourseValue, type: .Mandatory))
        progress.append(RequirementItem(description: "3 Credits Approved Elective ", percentage: unsupportedCourseValue, type: .Mandatory))
        
        return progress
    }
}