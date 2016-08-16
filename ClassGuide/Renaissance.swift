//
//  Renaissance.swift
//  ClassGuide
//
//  Created by Jesse Chen on 8/15/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

class Renaissance: ReqSet {
    static let sharedInstance = Renaissance() as ReqSet
    let title = "Renaissance"
    let key = SettingsKey.Renaissance
    
    var FxxxCourses = RequirementItem(fulfillment: 4, description: "4(Fxxx) (Core) ", type: .Mandatory, supported: .Supported)
    var differentHundredths = RequirementItem(fulfillment: 2, description: "Fyxx & Fzxx | y != z (Core) ", type: .Mandatory, supported: .Supported)
    var hundredthsIs2or8 = RequirementItem(fulfillment: 1, description: "Fyxx | y == 2 or 8 (Core) ", type: .Mandatory, supported: .Supported)
    var seenFxxx: [Int] = []
    var seenHundredths: [Int] = []
    var reqItems: [RequirementItem]!
    
    init() {
        reqItems = [
            FxxxCourses,
            differentHundredths,
            hundredthsIs2or8
        ]
    }
    
    func resetProgress() {
        reqItems.forEach({ (item: RequirementItem) in item.reset() })
        seenFxxx = []
        seenHundredths = []
    }
    
    func analyzeCourse(course: Course) {
        let courseIsFXXX = checkFxxx(course)
        if courseIsFXXX && !seenFxxx.contains(course.courseNumber) {
            FxxxCourses.increment(course)
            seenFxxx.append(course.courseNumber)
        }
        if courseIsFXXX && !seenHundredths.contains(getHundredths(course)) {
            seenHundredths.append(getHundredths(course))
            differentHundredths.increment(course)
        }
        if courseIsFXXX && (getHundredths(course) == 2 || getHundredths(course) == 8) {
            hundredthsIs2or8.increment(course)
        }
    }
}
