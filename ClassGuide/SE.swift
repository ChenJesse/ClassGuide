//
//  SE.swift
//  ClassGuide
//
//  Created by Jesse Chen on 8/15/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

class SE: ReqSet {
    static let sharedInstance = SE() as ReqSet
    let title = "Software Engineering"
    let key = SettingsKey.SE
    
    var taken5150or5152 = RequirementItem(fulfillment: 1, description: "CS5150/CS5152 (Core) ", type: .Mandatory, supported: .Supported)
    var practicumsFulfilled = RequirementItem(fulfillment: 2, description: "2(Practicums) (Core) ", type: .Mandatory, supported: .Supported)
    var seenPracticums: [Int] = []
    var taken4152or4154orF45xor5300or5412or5414or5625or5643or6620or6630or6650 = RequirementItem(fulfillment: 1, description: "CS4152/CS4154/CSF45x/CS5300/CS5412/CS5414/CS5625/CS5643/CS6620/CS6630/CS6650 (Core) ", type: .Mandatory, supported: .Supported)
    var reqItems: [RequirementItem]!
    
    init() {
        reqItems = [
            taken5150or5152,
            practicumsFulfilled,
            taken4152or4154orF45xor5300or5412or5414or5625or5643or6620or6630or6650
        ]
    }
    
    func analyzeCourse(course: Course) {
        if course.courseNumber == 5150 || course.courseNumber == 5152 {
            taken5150or5152.increment(course)
        } else if checkPracticum(course) && !seenPracticums.contains(course.courseNumber) {
            seenPracticums.append(course.courseNumber)
            practicumsFulfilled.increment(course)
        } else if checkHeavyImplementationComponent(course) {
            taken4152or4154orF45xor5300or5412or5414or5625or5643or6620or6630or6650.increment(course)
        }
    }
    
    func checkHeavyImplementationComponent(course: Course) -> Bool {
        return (
            course.courseNumber == 4152 ||
                course.courseNumber == 4154 ||
                checkFxxx(course) && getHundredths(course) == 4 && getTenths(course) == 5 ||
                course.courseNumber == 5300 ||
                course.courseNumber == 5412 ||
                course.courseNumber == 5414 ||
                course.courseNumber == 5625 ||
                course.courseNumber == 5643 ||
                course.courseNumber == 6620 ||
                course.courseNumber == 6630 ||
                course.courseNumber == 6650
        )
    }
    
    func resetProgress() {
        reqItems.forEach({ (item: RequirementItem) in item.reset() })
        seenPracticums.removeAll()
    }
}