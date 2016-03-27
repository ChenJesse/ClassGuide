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

public class CSRequirements {
    
    //MARK: Requirement number that must be fulfilled in each category
    public let introProgrammingRequirement = 1 // 111x and 2110/2112
    public let coreRequirement = 5 //2800, 3110, 3410, 4410, 4820
    public let electivesRequirement = 3 //electives 4000+
    public let projectRequirement = 1 //project course
    
    //MARK: Requirements already fulfilled (or selected classes that plan to fulfill)
    public var introProgrammingFulfilled = 0
    public var coreFulfilled = 0
    public var electivesFulfilled = 0
    public var projectFulfilled = 0
    
    internal init (courses: [Course]) {
        for course in courses {
            analyzeCourse(course)
        }
    }
    
    internal func analyzeCourse(course: Course) {
        if checkPracticum(course) || checkProject(course) { projectFulfilled += 1 }
        else if checkIntroProgramming(course) { introProgrammingFulfilled += 1 }
        else if checkCore(course) { coreFulfilled += 1 }
    }
}