//
//  CSRequirements.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/24/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

//All the project courses that are not practicums (practicums are a subset)

public class CSRequirements: ReqSet {
    static let sharedInstance = CSRequirements() as ReqSet
    let title = "CS Major Requirements"
    let key = SettingsKey.CS
    //MARK: Requirement number that must be fulfilled in each category
    let requiredCourses = 11
    
    //MARK: Requirements already fulfilled (or selected classes that plan to fulfill)
    public var taken111x = RequirementItem(fulfillment: 1, description: "CS111x (Intro) ", type: .Mandatory, supported: .Supported)
    public var taken2110or2112 = RequirementItem(fulfillment: 1, description: "CS2110/CS2112 (Intro) ", type: .Mandatory, supported: .Supported)
    public var taken2800 = RequirementItem(fulfillment: 1, description: "CS2800 (Core) ", type: .Mandatory, supported: .Supported)
    public var taken3110 = RequirementItem(fulfillment: 1, description: "CS3110 (Core) ", type: .Mandatory, supported: .Supported)
    public var taken3410 = RequirementItem(fulfillment: 1, description: "CS3410 (Core) ", type: .Mandatory, supported: .Supported)
    public var taken4410 = RequirementItem(fulfillment: 1, description: "CS4410 (Core) ", type: .Mandatory, supported: .Supported)
    public var taken4820 = RequirementItem(fulfillment: 1, description: "CS4820 (Core) ", type: .Mandatory, supported: .Supported)
    public var takenProject = RequirementItem(fulfillment: 1, description: "Project Course (Core) ", type: .Mandatory, supported: .Supported)
    public var takenElectives = RequirementItem(fulfillment: 3, description: "3(CS4000+) (Electives) ", type: .Mandatory, supported: .Supported)
    public var reqItems: [RequirementItem]!
    
    init() {
        reqItems = [
            taken111x,
            taken2110or2112,
            taken2800,
            taken3110,
            taken3410,
            taken4410,
            taken4820,
            takenElectives,
            takenProject,
            RequirementItem(fulfillment: 0, description: "Calculus Sequence ", type: .Mandatory, supported: .Unsupported),
            RequirementItem(fulfillment: 0, description: "Probability Course ", type: .Mandatory, supported: .Unsupported),
            RequirementItem(fulfillment: 0, description: "3(Technical Electives, 3000+) ", type: .Mandatory, supported: .Unsupported),
            RequirementItem(fulfillment: 0, description: "3(External Specialization, 3000+) ", type: .Mandatory, supported: .Unsupported),
            RequirementItem(fulfillment: 0, description: "3 Credits Approved Elective ", type: .Mandatory, supported: .Unsupported)
        ]
    }
    
    var seenElectives: [Int] = []
    
    func resetProgress() {
        reqItems.forEach({ (item: RequirementItem) in item.reset() })
        seenElectives = []
    }
    
    func analyzeCourse(course: Course) {
        if checkPracticum(course) || checkProject(course) { takenProject.increment(course) }
        else if getThousands(course) == 1 && getHundredths(course) == 1 && getTenths(course) == 1 {
            taken111x.increment(course)
        } else if course.courseNumber == 2110 || course.courseNumber == 2112 {
            taken2110or2112.increment(course)
        }
        else if course.courseNumber == 2800 { taken2800.increment(course) }
        else if course.courseNumber == 3110 { taken3110.increment(course) }
        else if course.courseNumber == 3410 { taken3410.increment(course) }
        else if course.courseNumber == 4410 { taken4410.increment(course) }
        else if course.courseNumber == 4820 { taken4820.increment(course) }
        else if checkFxxx(course) && !seenElectives.contains(course.courseNumber) {
            takenElectives.increment(course)
            seenElectives.append(course.courseNumber)
        }
    }
}