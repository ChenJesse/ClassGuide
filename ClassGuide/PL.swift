//
//  PL.swift
//  ClassGuide
//
//  Created by Jesse Chen on 8/15/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

class PL: ReqSet {
    static let sharedInstance = PL() as ReqSet
    let title = "Programming Languages"
    let key = SettingsKey.PL
    
    var takenF110 = RequirementItem(fulfillment: 1, description: "CSF110 (Core) ", type: .Mandatory, supported: .Supported)
    var taken4120 = RequirementItem(fulfillment: 1, description: "CS4120 (Core) ", type: .Mandatory, supported: .Supported)
    var taken4121 = RequirementItem(fulfillment: 1, description: "CS4121 (Core) ", type: .Mandatory, supported: .Supported)
    var taken4860or5114or5860orF810or6110 = RequirementItem(fulfillment: 1, description: "CS4860/CS5114/CS5860/CSF810/CS6110 (Core) ", type: .Mandatory, supported: .Supported)
    var taken202x = RequirementItem(fulfillment: 1, description: "CS202x (Core) ", type: .Mandatory, supported: .Supported)
    var reqItems: [RequirementItem]!
    
    init() {
        reqItems = [
            takenF110,
            taken4120,
            taken4121,
            taken4860or5114or5860orF810or6110,
            taken202x
        ]
    }
    
    func analyzeCourse(course: Course) {
        let isFxxx = checkFxxx(course)
        let thousandsDigit = getThousands(course)
        let hundredthsDigit = getHundredths(course)
        let tenthsDigit = getTenths(course)
        let onesDigit = getOnes(course)
        if isFxxx && hundredthsDigit == 1 && tenthsDigit == 1 && onesDigit == 0 {
            takenF110.increment(course)
        } else if course.courseNumber == 4120 {
            taken4120.increment(course)
        } else if course.courseNumber == 4121 {
            taken4121.increment(course)
        } else if (course.courseNumber == 4860 || course.courseNumber == 5114 || course.courseNumber == 5860 ||
            (isFxxx && hundredthsDigit == 8 && tenthsDigit == 1 && onesDigit == 0) || course.courseNumber == 6110) {
            taken4860or5114or5860orF810or6110.increment(course)
        }
        
        if (thousandsDigit == 2 && hundredthsDigit == 0 && tenthsDigit == 2) {
            taken202x.increment(course)
        }
    }
    
    func resetProgress() {
        reqItems.forEach({ (item: RequirementItem) in item.reset() })
    }
}