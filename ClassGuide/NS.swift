//
//  NS.swift
//  ClassGuide
//
//  Created by Jesse Chen on 8/15/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

class NS: ReqSet {
    static let sharedInstance = NS() as ReqSet
    let title = "Network Science"
    let key = SettingsKey.NS
    
    var x85xor4220Fulfilled = RequirementItem(fulfillment: 2, description: "CSx86x/INFO4220 (Core) ", type: .Mandatory, supported: .Supported)
    var seen: [Int] = []
    var takenF78xor4758 = RequirementItem(fulfillment: 1, description: "CSF76x/4758 (Core) ", type: .Mandatory, supported: .Supported)
    var reqItems: [RequirementItem]!
    
    init() {
        reqItems = [
            x85xor4220Fulfilled,
            takenF78xor4758,
            RequirementItem(fulfillment: 1, description: "ORIEx350/ECON4010/ECON4020/SOC3040/SOC4250/SOC5270/CSF84x/INFO4220 (Core) ", type: .Mandatory, supported: .Unsupported)
        ]
    }
    
    func analyzeCourse(course: Course) {
        let isFxxx = checkFxxx(course)
        if (!seen.contains(course.courseNumber) &&
            (getHundredths(course) == 8 && getTenths(course) == 5) || course.courseNumber == 4220)  {
            seen.append(course.courseNumber)
            x85xor4220Fulfilled.increment(course)
        } else if (isFxxx && ((getHundredths(course) == 7 && getTenths(course) == 8) || course.courseNumber == 4758)) {
            takenF78xor4758.increment(course)
        }
    }
    
    func resetProgress() {
        reqItems.forEach({ (item: RequirementItem) in item.reset() })
        seen.removeAll()
    }
}